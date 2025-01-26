// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract Goods {
    struct TraceData {
        address operator;
        uint8 status; //{0:create,1:transfer,2:upload,3:consumer}
        uint256 timestamp;
        string remark;
    }
    uint256 goodsID;
    uint8 currentStatus;
    uint8 constant STATUS_CREATE = 0;
    TraceData[] traceDatas;

    event NewStatus(address _operator,uint8 _status,uint256 _time,string _remark);

    constructor(uint256 _goodsID) {
        goodsID = _goodsID;
        currentStatus = STATUS_CREATE;
        traceDatas.push(TraceData(msg.sender,STATUS_CREATE,block.timestamp,"create goods"));
    }

    function changeStatus(uint8 _status,string memory _remark) public returns(bool) {
        currentStatus = _status;
        traceDatas.push(TraceData(msg.sender,_status,block.timestamp,_remark));
        emit NewStatus(msg.sender,_status,block.timestamp,_remark);
        return true;
    }

    function getStatus() public view returns(uint8) {
        return currentStatus;
    }

    function getTraceInfo() public view returns(TraceData[] memory) {
        return traceDatas;
    }
}