const hre = require("hardhat");

async function main() {
  const GhostToken = await hre.ethers.getContractFactory("GhostToken");
  const ghostToken = await GhostToken.deploy(1000000000000);

  await ghostToken.deployed();

  console.log("GhostToken deployed to:", ghostToken.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
