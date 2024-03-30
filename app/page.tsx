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
  const contract = new alchemyWeb3.eth.Contract(abi, "0x794a61358D6845594F94dc1DB02A252b5b4814aD");
  let collateral_amount = "0";
  let debt_amount = "0";
    async function readData() {
      const collateral = await contract.methods.getUserAccountData(account.address!).call();
      collateral_amount = collateral["totalCollateralBase"];
      debt_amount = collateral["totalDebtBase"];
    };
    readData();
  
  return (
    <main className="flex flex-col items-center justify-center gap-[20px] p-4">
      <ConnectButton showBalance />
    
			<Trove address={account.address!} chain={account.chain?.name!} collateral={collateral_amount} debt={debt_amount} />
    </main>
  );
}
