// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

library MarriageWitness {
    struct Person {
        mapping(address => bool) isExist;
        mapping(address => string) summary;
    }

    function isUserExist(Person storage _role,address _person) internal view returns(bool) {
        if(_person == address(0)) {
            return false;
        }
        return _role.isExist[_person];
    }

    function addPerson(Person storage _role,address _person,string memory _summary) internal returns(bool) {
        if(isUserExist(_role,_person)) {
            return false;
        }
        _role.isExist[_person] = true;
        _role.summary[_person] = _summary;
        return true;
    }

    function removePerson(Person storage _role,address _person) internal returns(bool) {
        if(!isUserExist(_role,_person)) {
            return false;
        }
        delete _role.isExist[_person];
        delete _role.summary[_person];
        return true;
    }

    function resetPerson(Person storage _role,address _person,string memory _summary) internal returns(bool) {
        if(!isUserExist(_role,_person)) {
            return false;
        }
        _role.summary[_person] = _summary;
        return true;
    }
}