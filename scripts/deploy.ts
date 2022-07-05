import { ethers } from "hardhat";

async function main() {
  const IterableMappingPosts = await ethers.getContractFactory(
    "IterableMappingPosts"
  );
  const mappingPosts = await IterableMappingPosts.deploy();
  await mappingPosts.deployed();

  const Root = await ethers.getContractFactory("Root", {
    libraries: {
      IterableMappingPosts: mappingPosts.address,
    },
  });
  const root = await Root.deploy();

  await root.deployed();

  console.log("Root deployed to:", root.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
