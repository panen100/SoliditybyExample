// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract RedPacket{
    bool internal immutable rType;
    uint8 internal rCount;
    uint256 internal immutable rAmount;
    address internal immutable owner;
    mapping(address => bool) internal hasAttend;
    LuckyGuy[] internal LuckyGuyDetails;

    struct LuckyGuy{
        address guy;
        uint money;
    }

    event WhoGetMoney(address _account,uint256 _num);
    
    error CallFailed();

    constructor(bool _Avg,uint8 _rCount,uint256 _rAmount) payable {
        require(_rAmount == msg.value,"_rAmount != msg.value");
        rType = _Avg;
        rCount = _rCount;
        rAmount = _rAmount;
        owner = msg.sender;
    }

    function getBalance() public view returns(uint256) {
        return address(this).balance;
    }

    function getRedPacket() external {
        require(!hasAttend[msg.sender],"sorry, you had attend this activity");
        require(msg.sender != owner,"owner cannot getRedPacket!");
        require(getBalance() > 0,"there is no money in the envelope!");

        if(rType){
            uint256 num = getBalance() / rCount;

            payable(msg.sender).transfer(num);

            emit WhoGetMoney(msg.sender, num);

            LuckyGuy memory luckyguy = LuckyGuy(msg.sender,num);
            LuckyGuyDetails.push(luckyguy);

            hasAttend[msg.sender] = true;

            rCount --;

        }else {
            if(rCount > 1){
                uint256 random_rate = uint256(
                keccak256(abi.encode(owner,rCount,rAmount,block.timestamp))
                ) % 10;

                uint256 random_num = (getBalance() * random_rate) / 10;

                (bool success,) = payable(msg.sender).call{value: random_num}("");
                if(!success){
                    revert CallFailed();
                }

                rCount --;

                emit WhoGetMoney(msg.sender, random_num);

                LuckyGuy memory luckyguy = LuckyGuy(msg.sender,random_num);
                LuckyGuyDetails.push(luckyguy);

                hasAttend[msg.sender] = true;

            }else {
                LuckyGuy memory luckyguy = LuckyGuy(msg.sender,getBalance());
                LuckyGuyDetails.push(luckyguy);

                hasAttend[msg.sender] = true;

                emit WhoGetMoney(msg.sender, getBalance());
                payable(msg.sender).transfer(getBalance());  
            }
        }
    }

    function getRedPacketDetail() external view returns(LuckyGuy[] memory) {
        return LuckyGuyDetails;
    }
}

