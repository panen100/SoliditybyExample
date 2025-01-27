const { ethers } = require("hardhat");

async function main() {
    // 获取合约工厂
    const MyContract = await ethers.getContractFactory("Marraiage");

    // 部署合约，并传递构造函数参数
    console.log("Deploying the contract Marraiage");
    const contract = await MyContract.deploy("Hello, Solidity!");
    await contract.deployed();

    console.log("Contract deployed to:", contract.address);

    // 验证部署是否成功
    const message = await contract.message();
    console.log("Initial message:", message);
}

// 捕获任何错误
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
