// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

// data contract
contract storageStructure{
    address public implementation; //logic contract address
    mapping(address => uint256) public points;
    uint256 public totalPlayers;
    address public owner;

    constructor() {
        owner = msg.sender;
    }
}

// logic contract 
contract implementationV1 is storageStructure{

    modifier onlyOwner(){
        require(msg.sender == owner, "Your are not owner.");
        _;
    }

    function addPlayer(address _player,uint256 _point) public virtual onlyOwner{
        require(points[_player] == 0, "Player already exits.");
        points[_player] = _point;
    }

    function setPlayer(address _player,uint256 _point) public onlyOwner{
        require(points[_player] != 0, "Player must already exists.");
        points[_player] = _point;
    }
}

// proxy contract
contract proxy is storageStructure{

    function setImpl(address _impl) public {
        implementation = _impl; 
    }

    fallback() external {
        address impl = implementation; //logic contract address
        require(impl != address(0), "implementation must already exists.");

        //底层调用
        //使用delegatecall时，对状态变量的更改会作用到proxyContract上
        assembly{
            let ptr := mload(0x40)
            calldatacopy(ptr,0,calldatasize())
            let result := delegatecall(gas(),impl,ptr,calldatasize(),0,0)
            let size := returndatasize()

            returndatacopy(ptr,0,size)

            switch result
                case 0 {revert(ptr,size)}
                default {return(ptr,size)}
        }
    }
}

// upgrade logic contract
contract implementationV2 is implementationV1{

    function addPlayer(address _player,uint256 _point) public override onlyOwner {
        require(points[_player] == 0, "player already exists");
        points[_player] = _point;
        totalPlayers ++;
    } 
}