"use client";
import Trove from "@/components/Trove";
import { ConnectButton } from "@rainbow-me/rainbowkit";
import { useAccount } from "wagmi";
import { abi } from "../abi/abi";
import { ethers, Contract } from "ethers";
import { useEffect } from "react";

export default function Home() {
  const account = useAccount();
  const provider = new ethers.BrowserProvider(window.ethereum);
  const contract = new Contract("0x764594F8e9757edE877B75716f8077162B251460", abi, provider);
    async function readData() {
      const collateral = await contract.getUserAccountData(account.address!);
      console.log(collateral);
    };
    readData();
  
  return (
    <main className="flex flex-col items-center justify-center gap-[20px] p-4">
      <ConnectButton showBalance />
      
			<Trove address={account.address!} chain={account.chain?.name!} collateral="" debt="" />
    </main>
  );
}
