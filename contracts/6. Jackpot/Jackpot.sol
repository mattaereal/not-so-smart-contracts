// SPDX-License-Identifier: MIT
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
        payable(msg.sender).transfer(amount * 2);
    }

    fallback() external payable {}
    receive() external payable {}
}

contract JackpotProxy {
    function claimPrize(address jackpot) external payable {
        uint256 amount = msg.value;
        require(amount > 0, "zero deposit");
        (bool success, ) = jackpot.call{value: amount}(
            abi.encodeWithSignature("claimPrize(uint)", amount)
        );
        require(success, "failed");
        payable(msg.sender).transfer(address(this).balance);
    }
    receive() external payable {}
}
