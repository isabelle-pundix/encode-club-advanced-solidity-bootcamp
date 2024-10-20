// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract Intro {
    function intro() public pure returns (uint16) {
        uint256 mol = 420;

        assembly {
            let fmp := mload(0x40) // Load fmp
            mstore(fmp, mol) // Store var in fmp
            mstore(0x40, add(fmp, 0x20)) // update fmp (32 bytes)
            return(add(fmp, 30), 0x02) // Return last 2 bytes (uint16)
        }
    }
}
