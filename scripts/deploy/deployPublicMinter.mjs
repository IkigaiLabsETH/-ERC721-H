import { deployAndVerify } from "../contract.mjs";
import dotenv from "dotenv";

dotenv.config({
  path: `.env.${process.env.CHAIN}`,
});

export async function deployPublicMinter(
  _cre8orAddress,
  _minterUtility,
  _collectionHolderMint,
  _friendsAndFamilyMinter
) {
  console.log("deploying public minter");
  const contractLocation = "src/minter/PublicMinter.sol:PublicMinter";
  const args = [
    _cre8orAddress,
    _minterUtility,
    _collectionHolderMint,
    _friendsAndFamilyMinter,
  ];
  const contract = await deployAndVerify(contractLocation, args);
  const contractAddress = contract.deployed.deploy.deployedTo;
  console.log("deployed public minter to ", contractAddress);
  console.log(
    "make sure to call grantRole with MINTER_ROLE on cre8ors contract"
  );
  return contract.deployed;
}
