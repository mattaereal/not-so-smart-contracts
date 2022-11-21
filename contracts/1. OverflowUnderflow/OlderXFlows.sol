// SPDX-License-Identifier: MIT

pragma solidity 0.8.17;

contract OlderXFlows {
    mapping (address => uint256) public balanceOf;
    function transfer(address _to, uint256 _value) public {
        /* Check if sender has balance */
        require(balanceOf[msg.sender] >= _value);
        /* Add and subtract new balances */
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
    }

    function transfer2(address _to, uint256 _value) public {
        /* Check if sender has balance and for overflows */
        require(balanceOf[msg.sender] >= _value && balanceOf[_to] + _value >= balanceOf[_to]);

        /* Add and subtract new balances */
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
    }

    using SafeMath for uint256;
    
    function transfer3(address _to, uint256 _value) {
        require(balanceOf[msg.sender] >= _value);
        balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
        balanceOf[_to] = balanceOf[_to].add(_value);
    }

    function transfer4(address _to, uint256 _value) {
        require(balanceOf[msg.sender] >= _value);
        unchecked {
            balanceOf[msg.sender] -= _value;
            balanceOf[_to] += _value;
        }
    }
}