# XYield
___
This is the beta version of CDP Yield Optimising strategy for Aave [deployed on Optimism mainnet](https://optimistic.etherscan.io/address/0x5Fb7505e5118f7CCd581Fb0f936B98d7073a7605):

CR = (totalCollateralBase / totalDebtBase)*100

Health factor = CR / 100

(totalDebtBase will almost remain constant while totalCollateralBase will be variable)

CR1: Current/real-time CR

CR2: CR at which tap-in should trigger

#### We have 3 user inputs/variables:
1. ⁠Tap-in threshold: TIT : Increase in CR from the current CR to trigger the tap-in sequence = (CR2 - CR1)

2. Tap-in gain: TIG : Percentage of the CR increase equivalent collateral to liquidate on tap-in. {Range: 0 - 100%}

3. Buy back threshold: BBT : Decrease in CR from the tap-in point i.e. CR2 to trigger the tap-out sequence {Minimum TOP: TIT*TIG/100}

Tap-in point in CR: CR2

Buy back point in CR: CR2 - BBT

#### Intermediate output parameters calculated from the frontend inputs and parsed to the contract:
- Tap-in point in collateral price: CR2*totalDebtBase/100
- Buy back point in collateral price: (CR2 - BBT)*totalDebtBase/100
- Collateral to liquidate on tap-in = (CR2 - CR1)*totalDebtBase*TIG/10000


Tap-in sequence: Withdraw collateral (equals to collateralToLiquidate) and then liquidate it to USDT on Uniswap

Buy back sequence: Buy back collateral from all the USDT on Uniswap and then deposit it all as the collateral to Aave pool.

___

Dependent contracts:
- Aave Gateway: 0xe9E52021f4e11DEAD8661812A0A6c8627abA2a54 
- Chainlink Price Feed: 0x13e3Ee699D1909E989722E753853AE30b17e08c5
- V3 Uniswap Router: 0xCb1355ff08Ab38bBCE60111F1bb2B784bE25D7e8
- USDT Contract Address: 0x94b008aA00579c1307B0EF2c499aD98a8ce58e58
