var Root = artifacts.require("./Root.sol");
var MappingPost = artifacts.require("./libraries/IterableMappingPosts.sol");
var Mapping = artifacts.require("./libraries/IterableMapping.sol");

module.exports = async function (deployer) {
  const mappingPosts = await deployer.deploy(MappingPost);
  const mapping = await deployer.deploy(Mapping);

  deployer.deploy(Root, mappingPosts.address, mapping.address);
};
