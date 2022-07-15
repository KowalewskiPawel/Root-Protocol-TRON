// var MyContract = artifacts.require("./MyContract.sol");
var RootContract = artifacts.require("./Root.sol");

module.exports = function (deployer) {
  deployer.deploy(RootContract);
};
