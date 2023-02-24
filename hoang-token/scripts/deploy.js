const hre = require("hardhat");

async function main() {
  const HoangToken = await hre.ethers.getContractFactory("HoangToken");
  const hoangToken = await HoangToken.deploy("HoangToken", "16", "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199");

  await hoangToken.deployed();

  console.log("Hoang Token deployed: ", hoangToken.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});