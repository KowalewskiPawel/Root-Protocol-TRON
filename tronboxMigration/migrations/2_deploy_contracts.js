// var MyContract = artifacts.require("./MyContract.sol");
var RootContract = artifacts.require("Root");
var mappingPosts = artifacts.require("IterableMappingPosts");

module.exports = function (deployer) {
  deployer.deploy(mappingPosts);
  deployer.link(RootContract, mappingPosts);
  deployer.deploy(RootContract, 10000, {
    fee_limit: 1.1e8,
    userFeePercentage: 31,
    originEnergyLimit: 1.1e8,
  });
};
