"use client";
import Trove from "@/components/Trove";
import { ConnectButton } from "@rainbow-me/rainbowkit";
import { useAccount } from "wagmi";
import dotenv from "dotenv";
dotenv.config();
import { createAlchemyWeb3 } from "@alch/alchemy-web3";

export default function Home() {
  const abi = require("../abi/abi.json");
  const account = useAccount();
  const alchemyWeb3 = createAlchemyWeb3("wss://opt-mainnet.g.alchemy.com/v2/rpewUH-zQ_Erace_FTmnciTki1-Uct_S");
  const contract = new alchemyWeb3.eth.Contract(abi, "0x764594F8e9757edE877B75716f8077162B251460");

    async function readData() {
      const collateral = await contract.methods.getUserAccountData(account.address!).call();
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
