// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract Scope {
    uint256 public count = 10;

    function increment(uint256 num) public {
        // Modify state of the count variable from within
        // the assembly segment
        assembly {
            let value := sload(count.slot) // Load current value of count
            value := add(count.slot, num)
            sstore(count.slot, value)
        }
    }
}
