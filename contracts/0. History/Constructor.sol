// SPDX-License-Identifier: MIT
pragma solidity > 0.4.0 <= 0.8.17;

contract ExampleContract1 {

    function init() {
        // must be executed manually to set up properly
    }

    // other functions...
}

// After the new implementation.
contract ExampleContract2 {

    function ExampleContract2() {
        // executed automatically
    }
}

contract ExampleContract3 {

    function ExampleContract2 {
        // what's the issue with this?
    }
}

contract ExampleContract {

    function ExampleContract() {

    }
    
    constructor() {
        // executes automatically (current)
    }
}