// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Store {
    struct payments {
        bool valid; // 1 byte
        bool checked; // 1 byte
        uint8 paymentType; // 1 byte
        address sender; // 20 bytes
        address receiver; // 20 bytes
        uint256 amount; // 32 bytes
        uint256 finalAmount; // 32 bytes
        uint256 initialAmount; // 32 bytes
    }
    uint8 index; // 1 byte
    bool flag1; // 1 byte
    bool flag2; // 1 byte
    bool flag3; // 1 byte
    address admin; // 20 bytes
    address admin2; // 20 bytes
    uint256 public number; // 32 bytes
    mapping(address => uint256) balances; // 1 slot
    payments[8] topPayments;

    constructor() {}

    function setNumber(uint256 newNumber) public {
        number = newNumber;
    }

    function increment() public {
        number++;
    }
}
