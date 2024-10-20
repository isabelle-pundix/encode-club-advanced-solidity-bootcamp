// Write some Yul to add 0x07 to 0x08.
// Store the result at the next free memory location.

// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract Week2 {
    function f() public pure returns (uint256 sum) {
        assembly {
            let fmp := mload(0x40) // Load the fmp
            let a := 7
            let b := 8
            sum := add(a, b) // Calculate the sum

            mstore(fmp, sum) // Store the sum at free memory location
            mstore(0x40, add(fmp, 0x20)) // update the fmp (32 bytes )
        }
    }
}
