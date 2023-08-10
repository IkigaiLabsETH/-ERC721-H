import { deployAndVerify } from "../contract.mjs";
import dotenv from "dotenv";

dotenv.config({
  path: `.env.${process.env.CHAIN}`,
});

export async function deployMinterUtilities(passportAddress) {
  console.log("deploying minter utilities");
  const contractLocation = "src/utils/MinterUtilities.sol:MinterUtilities";
  // 0.05 ETH
  const tier1Price = "50000000000000000";
  // 0.1 ETH
  const tier2Price = "100000000000000000";
  // 0.15 ETH
  const tier3Price = "150000000000000000";
  const args = [passportAddress, tier1Price, tier2Price, tier3Price];
  const contract = await deployAndVerify(contractLocation, args);
  const contractAddress = contract.deployed.deploy.deployedTo;
  console.log("deployed minter utilities to ", contractAddress);
  return contract.deployed;
}
