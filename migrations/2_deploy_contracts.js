const Cosmium = artifacts.require("./cosmium.sol");

module.exports = function(deployer) {
  deployer.deploy(Cosmium, 1000000);
};
