// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.26;

contract Level2Template {
    function solution(
        uint256[10] calldata unsortedArray
    ) external pure returns (uint256[10] memory sortedArray) {
        for (uint8 i = 0; i < 10; ) {
            sortedArray[i] = unsortedArray[i];

            unchecked {
                i++;
            }
        }

        for (uint8 i = 0; i < 9; ) {
            uint8 minIndex = i;

            for (uint8 j = i + 1; j < 10; ) {
                if (sortedArray[j] < sortedArray[minIndex]) {
                    minIndex = j;
                }
                unchecked {
                    j++;
                }
            }

            if (minIndex != i) {
                (sortedArray[i], sortedArray[minIndex]) = (
                    sortedArray[minIndex],
                    sortedArray[i]
                );
            }

            unchecked {
                i++;
            }
        }
    }
}
