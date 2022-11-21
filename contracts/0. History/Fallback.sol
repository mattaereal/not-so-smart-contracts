// SPDX-License-Identifier: MIT
pragma solidity > 0.4.0 <= 0.8.17;

contract ExampleFallback {
    // first ideas
    function fallback() {}
    fallback {}

    // used for a while
    function () {}

    // current
    fallback() external payable {}

    receive() external payable {}
}