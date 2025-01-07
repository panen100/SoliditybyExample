// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract AirDrop{
    mapping(address => uint256) public failTransferList;

    function getSum(uint256[] calldata _arr) public pure returns(uint sum) {
        for(uint i = 0;i < _arr.length;i++){
            sum = sum + _arr[i];
        }
    }

    function multiTransferToken(
        address _token,
        address[] calldata _addresses,
        uint256[] calldata _amounts //记录 空投数量 的数组，对应_addresses里每个地址的数量
    ) external {
        require(_addresses.length == _amounts.length, "Lengths of Addresses and Amounts not Equal");
        IERC20 token = IERC20(_token);
        uint _amountSum = getSum(_amounts);  //计算空投代币总量

        //检查：授权代币数量 >= 空投代币数量
        require(token.allowance(msg.sender,address(this)) >= _amountSum,"Need Approve ERC20 token");

        for(uint8 i;i < _addresses.length;i++){
            token.transferFrom(msg.sender,_addresses[i],_amounts[i]);
        }
    }

    function multiTransferETH(
        address payable[] calldata _addresses,
        uint256[] calldata _amounts
    ) public payable{
        require(_addresses.length == _amounts.length,"Lengths of Addresses and Amount Not Equal");
        uint _amountSum = getSum(_amounts); //计算空投ETH总量

        //计算转入ETH等于空投总量
        require(msg.value == _amountSum,"Transfer amount error");

        for(uint i = 0;i < _addresses.length;i++){
            (bool success,) = _addresses[i].call{value:_amounts[i]}("");
            if(!success){
                failTransferList[_addresses[i]] = _amounts[i];
            } 
            //_addresses[i].transfer(_amounts[i]); 有DOS攻击风险，并且transfer也是不推荐的写法
        }
    }
}