// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26 ;

interface ICallee{
    function setName(string memory _name) external;
    function getName() external view returns(string memory);
}

contract Caller{
    ICallee callee;

    constructor(address _addr) { 
        callee = ICallee(_addr);
    }

    function call(string memory _name) public returns(string memory myName) {
        callee.setName(_name);
        myName = callee.getName();
    }
}

contract Callee{
    string myname;

    function setName(string memory _name) external {
        myname = _name;
    }

    function getName() external view returns(string memory) {
        return myname;
    }
}