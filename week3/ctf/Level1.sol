// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.26;

contract Level1Template {
    function solution(
        uint256[2][3] calldata x,
        uint256[2][3] calldata y
    ) external pure returns (uint256[2][3] memory finalArray) {
        uint8 i = 0;
        uint8 j = 0;

        for (i = 0; i < 3; ) {
            for (j = 0; j < 2; ) {
                finalArray[i][j] = x[i][j] + y[i][j];

                unchecked {
                    j++;
                }
            }

            unchecked {
                i++;
            }
        }
    }
}
