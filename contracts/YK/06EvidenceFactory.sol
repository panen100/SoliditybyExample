// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import './06Evidence.sol';

contract EvidenceFactory is Ievidence{
    
    mapping(string => address) evi_keys; //每个存证对应的地址
    address[] signers; //签名者

    event NewEvidence(string _evi,address _sender,address _eviAddr);

    //初始化签名者的数组
    constructor(address[] memory _signers) {
        for(uint256 i=0;i < _signers.length;i++){
            signers.push(_signers[i]);
        }
    }

    //验证某一个用户是否是签名者，返回true或false
    function verify(address _signer) external view returns(bool){
        for(uint256 i = 0;i < signers.length;i++){
            if(signers[i] == _signer){
                return true;
            }else{
                return false;
            }
        }
    }

    //通过索引查询签名者的地址
    function getSigner(uint256 _index) external view returns(address){
        if(_index < signers.length){
            return signers[_index];
        }else{
            return address(0);
        }
    }

    //查询签名者的数量
    function getSignerSize() external view returns(uint256){
        return signers.length;
    }

    //创建存证
    function newEvidence(string memory _evi,string memory _key) public returns(address){
        Evidence evidence = new Evidence(_evi,address(this));
        evi_keys[_key] = address(evidence);
        
        emit NewEvidence(_evi,msg.sender,address(evidence));

        return address(evidence);
    }

    //查看存证
    function getEvidence(string memory _key) public view returns(string memory,address[] memory,address[] memory){
        address addr = evi_keys[_key];
        return Evidence(addr).getEvidence();
    }

    //签名的功能
    function sign(string memory _key) public returns(bool) {
        address addr = evi_keys[_key];
        return Evidence(addr).sign();
    }

    function isAllSigned(string memory _key) public view returns(bool,string memory){
        address addr = evi_keys[_key];
        return Evidence(addr).isAllSigned();
    }
}