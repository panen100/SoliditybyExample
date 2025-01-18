// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

//创建接口，EvidenceFactory合约实现接口定义的函数，供Evidence合约调用
interface Ievidence{
    function verify(address _signer) external view returns(bool);
    function sign() external returns(bool);
    function getEvidence() external view returns(string memory,address[] memory,address[] memory);
}


contract MarriageEvidence is Ievidence{
    string evidence; //存证的详情信息
    address[] needSigners; //需要签名的signer集合
    address[] signers; //已经签过名的signer集合

    event NewSignatureEvidence(string _evi,address _sender);
    event RepeatedSignature(string _evi,address _sender);
    event AddSigniture(string _evi,address _sender);

    constructor(string memory _evi,address _a,address _b){
        require(address(0) != _a,"_a is a invalid address");
        require(address(0) != _b,"_b is a invalid address");
        require(_a != tx.origin,"_a can not be a marriage witness");
        require(_b != tx.origin,"_b can not be a marriage witness");
        needSigners.push(tx.origin);
        needSigners.push(_a);
        needSigners.push(_b);
        signers.push(tx.origin);
        evidence = _evi;

        emit NewSignatureEvidence(_evi,tx.origin);
    }

    //查询存证信息、签名者列表、已签名的列表
    function getEvidence() external view returns(string memory,address[] memory,address[] memory){
        return(evidence,needSigners,signers);
    }

    //验证某一个用户是否是签名者，返回true或false
    function verify(address _signer) external view returns(bool){
        _verify(_signer);
    }

    //验证某一个用户是否是签名者，返回true或false
    function _verify(address _signer) internal view returns(bool){
        for(uint256 i = 0;i < needSigners.length;i++){
            if(signers[i] == _signer){
                return true;
            }
        }
        return false;
    }

    //签名的功能
    function sign() external returns(bool){
        require(_verify(tx.origin),"signer is not valid"); //只有签名者才有权限做签名操作
        if(_isSigned(tx.origin)){
            emit RepeatedSignature(evidence,tx.origin);
            return true;
        }
        signers.push(tx.origin);
        emit AddSigniture(evidence,tx.origin);
        return true;
    }

    //查询签名者是否已签名
    function _isSigned(address _signer) internal view returns(bool){
        for(uint256 i = 0;i < signers.length;i++){
            if(signers[i] == _signer){
                return true;
            }
        }
    }

    //查询是否所有用户都签过名
    function isAllSigned() public view returns(bool, string memory){
        for(uint256 i = 0;i < needSigners.length;i++){
            if(!_isSigned(needSigners[i])){
                return (false,"");
            }
        }  
        return (true,evidence); 
    }
}