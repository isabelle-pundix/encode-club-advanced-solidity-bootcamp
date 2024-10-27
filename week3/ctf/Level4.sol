// SPDX-License-Identifier: MIT

pragma solidity 0.8.26;

contract Level4Template {
    function solution(uint256 number) external pure returns (uint256) {
        uint256 power = 1;

        if (number == 0) {
            return 0;
        }

        while (power <= number / 2) {
            power *= 2;
        }

        return power;
    }
}
