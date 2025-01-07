// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract tokenFaucet{
    uint8 public constant amountAllowed = 100; //每次领取100单位代币
    address public tokenContract; //token的合约地址
    mapping(address => bool) public requestedAddress; //记录领取过的代币地址

    event SendToken(address indexed Receiver,uint256 indexed Amount);

    constructor(address _tokenContract) {
        tokenContract = _tokenContract;
    }

    function requestToken() external {
        IERC20 token = IERC20(tokenContract);

        require(!requestedAddress[msg.sender],"Can't Request Multiple Times!");
        require(token.balanceOf(address(this)) >= amountAllowed,"Faucet Empty!");

        token.transfer(msg.sender,amountAllowed);
        requestedAddress[msg.sender] = true;

        emit SendToken(msg.sender,amountAllowed);
    }
}