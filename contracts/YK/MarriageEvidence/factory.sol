// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import './evidence.sol';

contract EvidenceFactory{
    
    mapping(string => address) evi_keys; //每个存证对应的地址

    event NewEvidence(string _evi,string _key,address _sender);


    //创建存证
    function newMarriageEvidence(string memory _evi,string memory _key,address _a,address _b) public returns(address){
        MarriageEvidence evidence = new MarriageEvidence(_evi,_a,_b);
        evi_keys[_key] = address(evidence);
        
        emit NewEvidence(_evi,_key,msg.sender);

        return address(evidence);
    }

    //查看存证
    function getEvidence(string memory _key) public view returns(string memory,address[] memory,address[] memory){
        address addr = evi_keys[_key];
        return MarriageEvidence(addr).getEvidence();
    }

    //签名的功能
    function sign(string memory _key) public returns(bool) {
        address addr = evi_keys[_key];
        return MarriageEvidence(addr).sign();
    }

    function isAllSigned(string memory _key) public view returns(bool,string memory){
        address addr = evi_keys[_key];
        return MarriageEvidence(addr).isAllSigned();
    }
}