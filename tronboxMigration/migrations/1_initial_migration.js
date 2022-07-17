const Root = artifacts.require("./Root.sol");
const MappingPost = artifacts.require("./libraries/IterableMappingPosts.sol");
const Base64 = artifacts.require("./libraries/Base64.sol");

module.exports = async function (deployer) {
  deployer
    .deploy(MappingPost)
    .then((DeployedMapping) => deployer.deploy(Root, DeployedMapping.address));
};
