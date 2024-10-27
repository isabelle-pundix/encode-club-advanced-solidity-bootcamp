// SPDX-License-Identifier: MIT

pragma solidity 0.8.26;

contract Level5Template {
    function solution(int256 a, int256 b) external pure returns (int256) {
        int256 sum = (a + b) / 2;

        if ((a + b) % 2 != 0) {
            sum += 1;
        }

        return sum;
    }
}
