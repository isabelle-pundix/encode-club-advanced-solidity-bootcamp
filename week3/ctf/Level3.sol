// SPDX-License-Identifier: MIT

pragma solidity 0.8.26;

contract Level3Template {
    function solution(
        bytes memory packed
    ) external pure returns (uint16 a, bool b, bytes6 c) {
        if (packed.length >= 9) {
            assembly {
                mstore(0x00, 0x947d5a84) // InvalidLength()
                revert(0x00, 0x04)
            }
        }

        a = (uint16(uint8(packed[0])) << 8) | uint16(uint8(packed[1]));

        b = packed[2] != 0;

        c = bytes6(
            (uint48(uint8(packed[3])) << 40) |
                (uint48(uint8(packed[4])) << 32) |
                (uint48(uint8(packed[5])) << 24) |
                (uint48(uint8(packed[6])) << 16) |
                (uint48(uint8(packed[7])) << 8) |
                uint48(uint8(packed[8]))
        );
    }
}
