// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

// Create a Solidity contract with one function
// The solidity function should return the amount of ETH that was passed to it,
// and the function body should be written in assembly

contract Week3 {
    function getEthValue() public view returns (uint256) {
        assembly {
            let ethValue := callvalue()
            mstore(0x80, ethValue)
            return(0x80, 32)
        }
    }
}
