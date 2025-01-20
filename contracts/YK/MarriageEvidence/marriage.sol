// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import './factory.sol';
import './marriageWitness.sol';

contract Marraiage is marriageWitness1{
    EvidenceFactory eviFactory;

    constructor() {
        addWitness(msg.sender,"witness1");
        eviFactory = new EvidenceFactory();
    }

    function newMarriageEvidence(string memory _evi,string memory _key,address _a,address _b) public {
        require(isWitness(msg.sender),"sender is not witness");
        eviFactory.newMarriageEvidence(_evi,_key,_a,_b);
    }

    function sign(string memory _key) public returns(bool) {
        return eviFactory.sign(_key);
    }

    function getEvidence(string memory _key) public view returns(string memory,address[] memory,address[] memory) {
        return eviFactory.getEvidence(_key);
    }

    function isAllSigned(string memory _key) public view returns(bool,string memory) {
        return eviFactory.isAllSigned(_key);
    }
}
