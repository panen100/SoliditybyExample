// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

//创建接口，EvidenceFactory合约实现接口定义的函数，供Evidence合约调用
interface Ievidence{
    function verify(address _signer) external view returns(bool);
    function getSigner(uint256 _index) external view returns(address);
    function getSignerSize() external view returns(uint256);
}


contract Evidence{
    string evidence; //存证的详情信息
    address[] signers; //已经签过名的signer集合
    address public factoryAddr;  //工厂合约的地址

    event NewSignatureEvidence(string _evi,address _sender);
    event RepeatedSignature(string _evi,address _sender);
    event AddSigniture(string _evi,address _sender);

    constructor(string memory _evi,address _factory){
        factoryAddr = _factory;
        require(callVerify(tx.origin),"signer is not valid"); //只有签名者才可以创建evidence合约
        evidence = _evi; //初始化存证的详情信息
        signers.push(tx.origin); //签名者部署Evidence合约,代表已签名

        emit NewSignatureEvidence(_evi,tx.origin);
    }

    function callVerify(address _signer) public view returns(bool){
        return Ievidence(factoryAddr).verify(_signer);
    }

    //查询存证信息、签名者列表、已签名的列表
    function getEvidence() public view returns(string memory,address[] memory,address[] memory){
        uint256 iSize = Ievidence(factoryAddr).getSignerSize();
        address[] memory signerList = new address[](iSize);
        for(uint i = 0;i < iSize;i++){
            signerList[i] = Ievidence(factoryAddr).getSigner(i);
        }
        return(evidence,signerList,signers);
    }

    //签名的功能
    function sign() public returns(bool){
        require(callVerify(tx.origin),"signer is not valid"); //只有签名者才有权限做签名操作
        if(isSigned(tx.origin)){
            emit RepeatedSignature(evidence,tx.origin);
            return true;
        }
        signers.push(tx.origin);
        emit AddSigniture(evidence,tx.origin);
        return true;
    }

    //查询签名者是否已签名
    function isSigned(address _signer) internal view returns(bool){
        for(uint256 i = 0;i < signers.length;i++){
            if(signers[i] == _signer){
                return true;
            }
        }
    }

    //查询是否所有用户都签过名
    function isAllSigned() public view returns(bool, string memory){
        uint256 iSize = Ievidence(factoryAddr).getSignerSize();
        for(uint256 i = 0;i < iSize;i++){
            if(isSigned(Ievidence(factoryAddr).getSigner(i))){
                return (false,"");
            }
        }  
        return (true,evidence); 
    }
}