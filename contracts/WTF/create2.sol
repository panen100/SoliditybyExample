// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import './create.sol';

contract PairFactory2{
    mapping(address => mapping(address => address)) public getPair;
    address[] public allPairs;

    function createPair2(address tokenA,address tokenB) external returns(address pairAddr) {
        require(tokenA != tokenB,'IDENTICAL_ADDRESSES');

        (address token0,address token1) = tokenA < tokenB ? (tokenA,tokenB) : (tokenB,tokenA);

        bytes32 salt = keccak256(abi.encodePacked(token0,token1));

        Pair pair = new Pair{salt: salt}();

        pair.initialize(tokenA,tokenB);

        pairAddr = address(pair);
        allPairs.push(pairAddr);
        getPair[tokenA][tokenB] = pairAddr;
        getPair[tokenB][tokenA] = pairAddr;
    }

    // 提前计算pair合约地址
    function calculateAddr(address tokenA, address tokenB) public view returns(address predictedAddress){
        require(tokenA != tokenB, 'IDENTICAL_ADDRESSES'); //避免tokenA和tokenB相同产生的冲突
        
        // 计算用tokenA和tokenB地址计算salt
        (address token0, address token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA); //将tokenA和tokenB按大小排序
        bytes32 salt = keccak256(abi.encodePacked(token0, token1));
        
        // 计算合约地址方法 hash()
        predictedAddress = address(uint160(uint(keccak256(abi.encodePacked(
            bytes1(0xff),
            address(this),
            salt,
            keccak256(type(Pair).creationCode)
            )))));
    }
}