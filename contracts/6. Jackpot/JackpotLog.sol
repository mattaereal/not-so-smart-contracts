// SPDX-License-Identifier: MIT
import "hardhat/console.sol";

pragma solidity 0.8.17;

contract Jackpot {
    address private jackpotProxy;

    constructor(address _jackpotProxy) payable {
        jackpotProxy = _jackpotProxy;
    }

    modifier onlyJackpotProxy() {
        require(msg.sender == jackpotProxy);
        _;
    }

    function claimPrize(uint256 amount) external payable onlyJackpotProxy {
        console.log("\t %s called Jackpot.claimPrize(%s)", msg.sender, amount);
        payable(msg.sender).transfer(amount * 2);
    }

    fallback() external payable {
        console.log("\t %s called fallback() with msg.value: %s", msg.sender, msg.value);
    }

    receive() external payable {}
}

contract JackpotProxy {
    function claimPrize(address jackpot) external payable {
        console.log("\t %s called JackpotProxy.claimPrize(%s)", msg.sender, jackpot);
        uint256 amount = msg.value;
        require(amount > 0, "zero deposit");
        console.log(
            "\t %s is trying to call jackpot.claimPrize(uint) with msg.value: %s",
            msg.sender,
            amount
        );
        (bool success, ) = jackpot.call{value: amount}(
            abi.encodeWithSignature("claimPrize(uint)", amount)
        );
        require(success, "failed");
        payable(msg.sender).transfer(address(this).balance);
    }

    function claimPrize256(address jackpot) external payable {
        console.log("\t %s called JackpotProxy.safe_claimPrize(%s)", msg.sender, jackpot);
        uint256 amount = msg.value;
        require(amount > 0, "zero deposit");
        console.log(
            "\t %s is trying to call jackpot.claimPrize(uint256) with msg.value: %s",
            msg.sender,
            amount
        );
        (bool success, ) = jackpot.call{value: amount}(
            abi.encodeWithSignature("claimPrize(uint256)", amount)
        );
        require(success, "failed");
        payable(msg.sender).transfer(address(this).balance);
    }

    function claimPrizeSafe(Jackpot jackpot) external payable {
        uint256 amount = msg.value;
        require(amount > 0, "zero deposit");
        jackpot.claimPrize{value: amount}(amount);
        payable(msg.sender).transfer(address(this).balance);
    }

    receive() external payable {}

    function encode() public view {
        console.logBytes(abi.encodeWithSignature("claimPrize(uint)", 1 ether));
        console.logBytes(abi.encodeWithSignature("claimPrize(uint256)", 1 ether));
    }
}
