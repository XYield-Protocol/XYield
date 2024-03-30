"use client";
import Trove from "@/components/Trove";
import { ConnectButton } from "@rainbow-me/rainbowkit";
import { useAccount } from "wagmi";
import dotenv from "dotenv";
dotenv.config();
import { createAlchemyWeb3 } from "@alch/alchemy-web3";
import React, { useEffect } from "react";

export interface IAmount {
  collateral: string;
  debt: string;
};

export default function Home() {
  const [amount, setAmount] = React.useState<IAmount>({
    collateral: "",
    debt: "",
  });
  const abi = require("../abi/abi.json");
  const account = useAccount();
  const alchemyWeb3 = createAlchemyWeb3("wss://opt-mainnet.g.alchemy.com/v2/rpewUH-zQ_Erace_FTmnciTki1-Uct_S");
  const contract = new alchemyWeb3.eth.Contract(abi, "0x794a61358D6845594F94dc1DB02A252b5b4814aD");
  
  useEffect(() => {
    const getAmount = async() => {
      const collateral = await contract.methods.getUserAccountData(account.address).call();
      setAmount({collateral: collateral["totalCollateralBase"], debt: collateral["totalDebtBase"]});
    };
  
    getAmount();
    
  })

  return (
    <main className="flex flex-col items-center justify-center gap-[20px] p-4">
      <ConnectButton showBalance />
    
			<Trove address={account.address!} chain={account.chain?.name!} collateral={(Number(amount.collateral)*1e-8).toString()} debt={(Number(amount.debt)*1e-8).toString()} />
    </main>
  );
}
