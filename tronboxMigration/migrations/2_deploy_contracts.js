// var MyContract = artifacts.require("./MyContract.sol");
var RootContract = artifacts.require("Root");

module.exports = function (deployer) {
  deployer.deploy(RootContract);
};
