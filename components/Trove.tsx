"use client";
import React, { MouseEvent } from 'react';
import { Address } from 'viem';

export interface ITroveProps {
  address: Address;
  chain: string;
  collateral: string;
  debt: string;
}
export interface IPercentProps {
  rcr_percent: string;
  r_percent: string;
  buyback_percent: string;
}

const Trove = ({address, chain, collateral, debt}: ITroveProps): React.JSX.Element => {
  const [ percent, setPercent ] = React.useState<IPercentProps>({
    rcr_percent: "",
    r_percent: "",
    buyback_percent: ""
  });

  const getRCRMaxAmount = (event: MouseEvent<HTMLButtonElement>) => {
    setPercent({...percent,  rcr_percent: "100"});
    event.preventDefault();
  };
  const getRPercentMaxAmount = (event: MouseEvent<HTMLButtonElement>) => {
    setPercent({...percent, r_percent: "100"});
    event.preventDefault();
  };
  const getBuyBackMaxAmount = (event: MouseEvent<HTMLButtonElement>) => {
    setPercent({...percent, buyback_percent: percent.rcr_percent});
    event.preventDefault();
  };

  return (
    <>
      <form className="sm:flex hidden flex-col items-center justify-center gap-[8px] p-[4px] rounded-[12px] border-2 border-[#202020]">
        <div className="flex flex-col items-center space-y-[5px]">
          <div className="max-w-[568px] w-[100vw] bg-[#1b1b1b] flex flex-col space-y-[3px] items-start justify-center p-4 rounded-[12px] border-2 border-[#202020] focus-within:border-[#404040]">
            <span className="text-xs text-[#9b9b9b]">Address</span>
            <div className="flex items-center justify-between w-full">
              <input 
                type="text" 
                value={address}
                className="w-full h-10 text-3xl bg-inherit outline-none placeholder:text-[#5d5d5d]" 
                placeholder="0x" />
            </div>
            <div className="text-[#9b9b9b] text-xs">Your {chain} wallet address</div>
          </div>
          <div className="max-w-[568px] w-[100vw] bg-[#1b1b1b] flex flex-col space-y-[3px] items-start justify-center p-4 rounded-[12px] border-2 border-[#202020] focus-within:border-[#404040]">
            <div className="flex items-center justify-center">
              <div className="flex flex-col w-1/2">
                <span className="text-xs text-[#9b9b9b]">Collateral Amount</span>
                <div className="flex items-center justify-between w-full">
                  <input 
                    type="text" 
                    value={collateral}
                    className="w-2/3 h-10 text-3xl bg-inherit outline-none placeholder:text-[#5d5d5d]" 
                    placeholder="0 ETH" />
                </div>
              </div>
              <div className="flex flex-col w-1/2">
                <span className="text-xs text-[#9b9b9b]">Debt Amount</span>
                <div className="flex items-center justify-between w-full">
                  <input 
                    type="text" 
                    value={debt}
                    className="w-2/3 h-10 text-3xl bg-inherit outline-none placeholder:text-[#5d5d5d]" 
                    placeholder="0 USD" />
                </div>
              </div>
            </div>
            <div className="text-[#9b9b9b] text-xs">You are Collateral Ratio is {Number(collateral)/Number(debt)}</div>
          </div>
          <div className="max-w-[568px] w-[100vw] bg-[#1b1b1b] flex flex-col space-y-[3px] items-start justify-center p-4 rounded-[12px] border-2 border-[#202020] focus-within:border-[#404040]">
            <span className="text-xs text-[#9b9b9b]">Redemption CR</span>
            <div className="flex items-center justify-between w-full">
              <input 
                type="text" 
                value={percent.rcr_percent}
                onChange={(e) => setPercent({...percent, rcr_percent: e.target.value})}
                className="w-1/2 h-10 text-3xl bg-inherit outline-none placeholder:text-[#5d5d5d]"                 
                placeholder="0%" />
              <button onClick={getRCRMaxAmount} className="w-1/2 h-full p-2 flex gap-2 items-center justify-center bg-[rgba(0,102,255,0.1)] text-base text-[#0066FF] font-medium rounded-[8px] outline-none">Max</button>
            </div>
            <div className="text-[#9b9b9b] text-xs">You have to add positive percent.</div>
          </div>
          <div className="max-w-[568px] w-[100vw] bg-[#1b1b1b] flex flex-col space-y-[3px] items-start justify-center p-4 rounded-[12px] border-2 border-[#202020] focus-within:border-[#404040]">
            <span className="text-xs text-[#9b9b9b]">Redemption Percent</span>
            <div className="flex items-center justify-between w-full">
              <input 
                type="text" 
                value={percent.r_percent}
                onChange={(e) => setPercent({...percent, r_percent: e.target.value})}
                className="w-1/2 h-10 text-3xl bg-inherit outline-none placeholder:text-[#5d5d5d]"                
                inputMode='decimal'
                placeholder="0%" />
              <button onClick={getRPercentMaxAmount} className="w-1/2 h-full p-2 flex gap-2 items-center justify-center bg-[rgba(0,102,255,0.1)] text-base text-[#0066FF] font-medium rounded-[8px] outline-none">Max</button>
            </div>
            <div className="text-[#9b9b9b] text-xs">You have add negative percent.</div>
          </div>
        </div>
          <div className="max-w-[568px] w-[100vw] bg-[#1b1b1b] flex flex-col space-y-[3px] items-start justify-center p-4 rounded-[12px] border-2 border-[#202020] focus-within:border-[#404040]">
            <span className="text-xs text-[#9b9b9b]">Buyback Percent</span>
            <div className="flex items-center justify-between w-full">
              <input 
                type="text" 
                value={percent.buyback_percent}
                className="w-1/2 h-10 text-3xl bg-inherit outline-none placeholder:text-[#5d5d5d]"    
                onChange={(e) => setPercent({...percent, buyback_percent: e.target.value})}             
                placeholder="0%" />
              <button onClick={getBuyBackMaxAmount} className="w-1/2 h-full p-2 flex gap-2 items-center justify-center bg-[rgba(0,102,255,0.1)] text-base text-[#0066FF] font-medium rounded-[8px] outline-none">Max</button>
            </div>
            <div className="text-[#9b9b9b] text-xs">You have add negative percent.</div>
          </div>
        <button type="submit" className="bg-[#311C31] text-[#FC72FF] w-full h-14 text-lg font-medium rounded-[10px]">Submit</button>
      </form>
    </>
  );
};

export default Trove;