const hre = require("hardhat");

async function main() {
  const GhostToken = await hre.ethers.getContractFactory("Greeter");
  const ghostToken = await GhostToken.deploy("Hello, Hardhat!");

  await ghostToken.deployed();

  console.log("GhostToken deployed to:", ghostToken.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
