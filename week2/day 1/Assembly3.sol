// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract SubOverflow {
    // Modify this function so that on overflow it returns the value 0
    // otherwise it should return x - y
    function subtract(uint256 x, uint256 y) public pure returns (uint256) {
        // Write assembly code that handles overflows
        assembly {
            switch gt(y, x)
            case 1 {
                mstore(0x0, 0)
            }
            default {
                mstore(0x0, sub(x, y))
            }
            return(0x0, 32)
        }
    }
}
