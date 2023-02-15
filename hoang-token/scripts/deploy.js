const hre = require("hardhat");

async function main() {
  const HoangToken = await hre.ethers.getContractFactory("HoangToken");
  const hoangToken = await HoangToken.deploy(100000000, 50);

  await hoangToken.deployed();

  console.log("Hoang Token deployed: ", hoangToken.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});