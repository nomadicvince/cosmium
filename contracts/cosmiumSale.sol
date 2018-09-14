pragma solidity ^0.4.24;
import "./cosmium.sol";

contract CosmiumSale {

    address admin;
    Cosmium public tokenContract;
    uint256 public tokenPrice;

    constructor(Cosmium _tokenContract, uint256 _tokenPrice) public {
        admin = msg.sender;
        tokenContract = _tokenContract;
        tokenPrice = _tokenPrice;
    }
}