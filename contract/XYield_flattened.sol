
// File: @uniswap/v3-core/contracts/interfaces/callback/IUniswapV3SwapCallback.sol


pragma solidity >=0.5.0;

/// @title Callback for IUniswapV3PoolActions#swap
/// @notice Any contract that calls IUniswapV3PoolActions#swap must implement this interface
interface IUniswapV3SwapCallback {
    /// @notice Called to `msg.sender` after executing a swap via IUniswapV3Pool#swap.
    /// @dev In the implementation you must pay the pool tokens owed for the swap.
    /// The caller of this method must be checked to be a UniswapV3Pool deployed by the canonical UniswapV3Factory.
    /// amount0Delta and amount1Delta can both be 0 if no tokens were swapped.
    /// @param amount0Delta The amount of token0 that was sent (negative) or must be received (positive) by the pool by
    /// the end of the swap. If positive, the callback must send that amount of token0 to the pool.
    /// @param amount1Delta The amount of token1 that was sent (negative) or must be received (positive) by the pool by
    /// the end of the swap. If positive, the callback must send that amount of token1 to the pool.
    /// @param data Any data passed through by the caller via the IUniswapV3PoolActions#swap call
    function uniswapV3SwapCallback(
        int256 amount0Delta,
        int256 amount1Delta,
        bytes calldata data
    ) external;
}

// File: @uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol


pragma solidity >=0.7.5;
pragma abicoder v2;


/// @title Router token swapping functionality
/// @notice Functions for swapping tokens via Uniswap V3
interface ISwapRouter is IUniswapV3SwapCallback {
    struct ExactInputSingleParams {
        address tokenIn;
        address tokenOut;
        uint24 fee;
        address recipient;
        uint256 deadline;
        uint256 amountIn;
        uint256 amountOutMinimum;
        uint160 sqrtPriceLimitX96;
    }

    /// @notice Swaps `amountIn` of one token for as much as possible of another token
    /// @param params The parameters necessary for the swap, encoded as `ExactInputSingleParams` in calldata
    /// @return amountOut The amount of the received token
    function exactInputSingle(ExactInputSingleParams calldata params) external payable returns (uint256 amountOut);

    struct ExactInputParams {
        bytes path;
        address recipient;
        uint256 deadline;
        uint256 amountIn;
        uint256 amountOutMinimum;
    }

    /// @notice Swaps `amountIn` of one token for as much as possible of another along the specified path
    /// @param params The parameters necessary for the multi-hop swap, encoded as `ExactInputParams` in calldata
    /// @return amountOut The amount of the received token
    function exactInput(ExactInputParams calldata params) external payable returns (uint256 amountOut);

    struct ExactOutputSingleParams {
        address tokenIn;
        address tokenOut;
        uint24 fee;
        address recipient;
        uint256 deadline;
        uint256 amountOut;
        uint256 amountInMaximum;
        uint160 sqrtPriceLimitX96;
    }

    /// @notice Swaps as little as possible of one token for `amountOut` of another token
    /// @param params The parameters necessary for the swap, encoded as `ExactOutputSingleParams` in calldata
    /// @return amountIn The amount of the input token
    function exactOutputSingle(ExactOutputSingleParams calldata params) external payable returns (uint256 amountIn);

    struct ExactOutputParams {
        bytes path;
        address recipient;
        uint256 deadline;
        uint256 amountOut;
        uint256 amountInMaximum;
    }

    /// @notice Swaps as little as possible of one token for `amountOut` of another along the specified path (reversed)
    /// @param params The parameters necessary for the multi-hop swap, encoded as `ExactOutputParams` in calldata
    /// @return amountIn The amount of the input token
    function exactOutput(ExactOutputParams calldata params) external payable returns (uint256 amountIn);
}

// File: @openzeppelin/contracts/token/ERC20/IERC20.sol


// OpenZeppelin Contracts (last updated v5.0.0) (token/ERC20/IERC20.sol)

pragma solidity ^0.8.20;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /**
     * @dev Returns the value of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the value of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves a `value` amount of tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 value) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets a `value` amount of tokens as the allowance of `spender` over the
     * caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 value) external returns (bool);

    /**
     * @dev Moves a `value` amount of tokens from `from` to `to` using the
     * allowance mechanism. `value` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address from, address to, uint256 value) external returns (bool);
}

// File: @chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol


pragma solidity ^0.8.0;

interface AggregatorV3Interface {
  function decimals() external view returns (uint8);

  function description() external view returns (string memory);

  function version() external view returns (uint256);

  function getRoundData(
    uint80 _roundId
  ) external view returns (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound);

  function latestRoundData()
    external
    view
    returns (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound);
}

// File: XYield.sol

//SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;




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