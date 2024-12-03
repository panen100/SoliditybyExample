// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract GuessGame{
    uint internal startTime;
    uint internal endTime;
    address internal owner;
    uint public bigTotalAmount;
    uint public smallTotalAmount;
    uint minAmount;
    Player[] internal bigs;
    Player[] internal smalls;
    bool internal isFinished;

    struct Player{
        address addr;
        uint amount;
    }

    event OpenResult(address _addr,uint _amount);

    constructor(uint _minAmount) {
        owner = msg.sender;
        startTime = block.timestamp;
        endTime = startTime + 60;
        minAmount = _minAmount;
    }

    modifier onlyOwner(){
        require(msg.sender == owner,"Only owner can open the box!");
        _;
    }

    function guessSize(bool _isBig,uint _amount) external payable {
        require(block.timestamp < endTime,"Game Over!");
        require(_amount == msg.value,"_amount != msg.value");
        require(_amount >= minAmount,"_amount < minAmount");

        if(_isBig){
            Player memory player = Player(msg.sender,msg.value);
            bigs.push(player);
            bigTotalAmount += _amount;
        }else {
            Player memory player = Player(msg.sender,msg.value);
            smalls.push(player);
            smallTotalAmount += _amount;
        }
    }

    function openBox() external payable onlyOwner {
        require(block.timestamp > endTime,"Game is not over!");
        require(!isFinished,"Already open the box.");
        isFinished = true;

        // random number between 1 to 9 is small
        // random number between 10~18 is big
        uint256 random_num = uint256(
            keccak256(abi.encode(block.timestamp,msg.sender))
            ) % 18;

        if(random_num <= 9){
            for(uint i = 0;i < smalls.length;i++){
                uint bonus = smalls[i].amount + ((smalls[i].amount * bigTotalAmount * 9) / (smallTotalAmount * 10));
                uint ServiceFee =  bigTotalAmount / 10;

                payable(smalls[i].addr).transfer(bonus);
                emit OpenResult(smalls[i].addr,bonus);

                payable(owner).transfer(ServiceFee);
                emit OpenResult(owner,ServiceFee);
            }
        }else {
           for(uint i = 0;i < smalls.length;i++){
                uint bonus = bigs[i].amount + ((bigs[i].amount * smallTotalAmount * 9)/ (bigTotalAmount * 10));
                uint ServiceFee = smallTotalAmount / 10;

                payable(bigs[i].addr).transfer(bonus);
                emit OpenResult(smalls[i].addr,bonus);

                payable(owner).transfer(ServiceFee);
                emit OpenResult(owner,ServiceFee);
            }
        } 
    }
}