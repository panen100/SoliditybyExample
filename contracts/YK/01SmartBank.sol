// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract smartbank{
    string public bankName;
    mapping(address => uint256) public balanceOf;
    uint256 public totalSupply;

    event Deposit(address account,uint256 amount);
    event Withdraw(address account,uint256 amount);
    event Transfer(address from,address to,uint256 amount);

    constructor(string memory _bankName) {
        bankName = _bankName;
    }

    function deposit(uint256 _amount) public payable {
        require(_amount > 0,"_amount <= 0");
        require(_amount == msg.value,"_amount != msg.value");
        balanceOf[msg.sender] += _amount;
        totalSupply += _amount;
        require(address(this).balance == totalSupply,"operation is revoked");

        emit Deposit(msg.sender, _amount);     
    }

    function withdraw(uint256 _amount) public {
        require(_amount > 0,"_amount <= 0");
        require(_amount <= balanceOf[msg.sender],"_amount > balanceOf[msg.sender]");
        balanceOf[msg.sender] -= _amount;
        totalSupply -= _amount;
        payable(msg.sender).transfer(_amount);
        require(address(this).balance == totalSupply,"operation is revoked");

        emit Withdraw(msg.sender, _amount); 
    }

    function transfer(address _to,uint256 _amount) public {
        require(_to != address(0),"receiver address is invalid");
        require(_amount >= 0,"_amount <= 0");
        balanceOf[msg.sender] -= _amount;
        balanceOf[_to] += _amount;

        emit Transfer(msg.sender,_to,_amount);
    }

    function getBalance() public view returns(uint256,uint256) {
        return (address(this).balance,totalSupply);
    }
}