// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import './GoodCategory.sol';

contract factory {
    struct GoodsCategory {
        Category categoryData;
        bool isExists;
    }
    mapping(bytes32 => GoodsCategory) goodsCategorys;

    event NewCateGory(address _operator,bytes32 _category);

    function newGoods(bytes32 _category,uint256 _goodsID) public  returns(Goods) {
        Category category = getCategory(_category);
        return category.createGoods(_goodsID);
    }

    function newCategory(bytes32 _category) public returns(Category) {
        require(!goodsCategorys[_category].isExists,"category already exists");

        Category category = new Category(_category);
        goodsCategorys[_category].isExists = true;
        goodsCategorys[_category].categoryData = category;

        emit NewCateGory(msg.sender,_category);
        return category;
    }

    function getCategory(bytes32 _category) public view returns(Category) {
        return goodsCategorys[_category].categoryData;
    }

    function getStatus(bytes32 _category,uint256 _goodsID) public view returns(uint8) {
        Category category = getCategory(_category);
        return category.getStatus(_goodsID);
    }

    function changeStatus(bytes32 _category,uint256 _goodsID,uint8 _status,string memory _remark) public returns(bool) {
        Category category = getCategory(_category);
        return category.changeStatus(_goodsID,_status,_remark);
    }

    function calculateCategory(string memory _name) public pure returns(bytes32) {
        return keccak256(abi.encode(_name));
    }

    function getTraceInfo(bytes32 _category,uint256 _goodsID) public view returns(Goods.TraceData[] memory) {
        Category category = getCategory(_category);
        return category.getTraceInfo(_goodsID);
    }
}