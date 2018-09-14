const Cosmium = artifacts.require("./cosmium.sol");
const CosmiumSale = artifacts.require("./cosmiumSale.sol");

module.exports = function(deployer) {
  deployer.deploy(Cosmium, 1000000).then(() => {
    let tokenPrice = 1000000000000000; // in wei
    return deployer.deploy(CosmiumSale, Cosmium.address, tokenPrice);
  });

};
