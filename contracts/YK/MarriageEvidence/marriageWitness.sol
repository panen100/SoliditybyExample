// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import './marriageWitness_library.sol';

contract marriageWitness1 {
    using MarriageWitness for MarriageWitness.Person;
    MarriageWitness.Person witness;
    address[] allWitness;
    address owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner,"not allowed");
        _;
    }

    function isWitness(address _person) public view returns(bool) {
        return witness.isUserExist(_person);
    } 

    function addWitness(address _person,string memory _summary) public onlyOwner returns(bool) {
        bool ok = witness.addPerson(_person,_summary);
        require(ok,"add witness failed");
        allWitness.push(_person);
        return true;
    }
    
    function removeWitness(address _person) public onlyOwner returns(bool) {
        bool ok = witness.removePerson(_person);
        require(ok,"remove witness failed");
        //delete array
        uint256 index = 0;
        for(;index<allWitness.length;index++) {
            if(_person == allWitness[index]) {
                break;
            }
        }

        if(index < allWitness.length - 1 ) {
            allWitness[index] = allWitness[allWitness.length-1];
            allWitness.pop();
        } else if(index == allWitness.length - 1) {
            allWitness.pop();
        }
        return true;
    }

    function resetWitness(address _person,string memory _summary) public onlyOwner returns(bool) {
        bool ok = witness.resetPerson(_person,_summary);
        require(ok,"reset witness failed");
        return true;
    }
}