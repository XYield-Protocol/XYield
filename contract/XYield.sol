//SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {ISwapRouter} from "@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol";

contract XYield {
    struct UserInputs {
        uint256 collateralTapInPrice;
        uint256 collateralBuyBackPrice;
        uint256 collateralToLiquidate;
    }

    mapping(address => UserInputs) public s_userProfile;
    AggregatorV3Interface immutable i_priceFeed;
    address[] private s_users;
    uint256 private lastTimeStamp;
    uint256 private constant INTERVAL = 60;
    uint256 private constant PRICE_FEED_PRECISION = 10 ** 8;

    IERC20 public immutable usdtToken;
    ISwapRouter public immutable swapRouter;
    uint24 public constant poolFee = 15000; // 0.15% fee tier

    address public immutable aaveGateway;

    constructor(
        address _priceFeed,
        address _usdtToken,
        address _swapRouter,
        address _aaveGateway
    ) {
        i_priceFeed = AggregatorV3Interface(_priceFeed);
        usdtToken = IERC20(_usdtToken);
        swapRouter = ISwapRouter(_swapRouter);
        aaveGateway = _aaveGateway;
        lastTimeStamp = block.timestamp;
    }

    function setUserProfile(
        uint256 _collateralTapInPrice,
        uint256 _collateralBuyBackPrice,
        uint256 _collateralToLiquidate
    ) external {
        s_userProfile[msg.sender] = UserInputs(
            _collateralTapInPrice,
            _collateralBuyBackPrice,
            _collateralToLiquidate
        );
        s_users.push(msg.sender);
    }

    function checkStatus() external {
        if ((block.timestamp - lastTimeStamp) > INTERVAL) {
            uint256 ethUsdPrice = getEthUsdPrice();

            for (uint256 i = 0; i < s_users.length; i++) {
                address user = s_users[i];
                UserInputs memory userInputs = s_userProfile[user];

                if (ethUsdPrice >= userInputs.collateralTapInPrice) {
                    tapIn(user, userInputs.collateralToLiquidate);
                } else if (ethUsdPrice <= userInputs.collateralBuyBackPrice) {
                    buyBack(user);
                }
            }

            lastTimeStamp = block.timestamp;
        }
    }

    function getEthUsdPrice() public view returns (uint256) {
        (
            ,
            int256 answer,
            ,
            ,

        ) = i_priceFeed.latestRoundData();

        return (uint256(answer) * PRICE_FEED_PRECISION);
    }

    function tapIn(address _user, uint256 _amount) internal {
        // Withdraw collateral (ETH) from Aave
        (bool success, ) = aaveGateway.call(
            abi.encodeWithSignature("withdrawETH(address,uint256,address)", _user, _amount, _user)
        );
        require(success, "Withdrawal from Aave failed");

        // Swap ETH for USDT on Uniswap
        ISwapRouter.ExactInputSingleParams memory params =
            ISwapRouter.ExactInputSingleParams({
                tokenIn: address(0), // Native ETH
                tokenOut: address(usdtToken),
                fee: poolFee,
                recipient: _user,
                deadline: block.timestamp,
                amountIn: _amount,
                amountOutMinimum: 0,
                sqrtPriceLimitX96: 0
            });

        swapRouter.exactInputSingle(params);
    }

    function buyBack(address _user) internal {
        // Get the USDT balance of the user
        uint256 usdtBalance = usdtToken.balanceOf(_user);

        // Approve the router to spend USDT
        usdtToken.approve(address(swapRouter), usdtBalance);

        // Swap USDT for ETH on Uniswap
        ISwapRouter.ExactOutputSingleParams memory params =
            ISwapRouter.ExactOutputSingleParams({
                tokenIn: address(usdtToken),
                tokenOut: address(0), // Native ETH
                fee: poolFee,
                recipient: _user,
                deadline: block.timestamp,
                amountOut: usdtBalance,
                amountInMaximum: type(uint256).max,
                sqrtPriceLimitX96: 0
            });

        swapRouter.exactOutputSingle(params);

        // Deposit ETH as collateral to Aave
        (bool success, ) = aaveGateway.call(
            abi.encodeWithSignature("depositETH(address,uint16)", _user, 0)
        );
        require(success, "Deposit to Aave failed");
    }
}