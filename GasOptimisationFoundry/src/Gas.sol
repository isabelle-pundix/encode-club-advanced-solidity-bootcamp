// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {Ownable} from "./Ownable.sol";

contract GasContract is Ownable {
    uint256 private constant MAX_ADMINS = 5;
    address[MAX_ADMINS] public administrators;
    uint256 public immutable totalSupply;
    uint256 public paymentCounter;

    mapping(address => uint256) public balances;
    mapping(address => Payment[]) public payments;
    mapping(address => uint256) public whitelist;
    mapping(address => ImportantStruct) public whiteListStruct;

    struct Payment {
        uint256 paymentID;
        address recipient;
        uint256 amount;
    }

    struct ImportantStruct {
        uint256 amount;
        bool paymentStatus;
    }

    event AddedToWhitelist(address userAddress, uint256 tier);
    event Transfer(address recipient, uint256 amount);
    event WhiteListTransfer(address indexed);

    error NotAuthorized();
    error InvalidTier();
    error NotWhiteListed();
    error InputError();
    error InsufficientBalance();

    modifier onlyAdminOrOwner() {
        if (!(checkForAdmin(msg.sender) || msg.sender == owner())) {
            revert NotAuthorized();
        }
        _;
    }

    constructor(address[] memory _admins, uint256 _totalSupply) {
        totalSupply = _totalSupply;
        for (uint256 i = 0; i < _admins.length && i < MAX_ADMINS; i++) {
            if (_admins[i] != address(0)) {
                administrators[i] = _admins[i];
                if (_admins[i] == owner()) {
                    balances[_admins[i]] = _totalSupply;
                }
            }
        }
    }

    function checkForAdmin(address _user) public view returns (bool) {
        for (uint256 i = 0; i < MAX_ADMINS; i++) {
            if (administrators[i] == _user) {
                return true;
            }
        }
        return false;
    }

    function balanceOf(address _user) external view returns (uint256) {
        return balances[_user];
    }

    function transfer(
        address _recipient,
        uint256 _amount,
        string calldata _name
    ) external returns (bool) {
        if (balances[msg.sender] < _amount) {
            revert InsufficientBalance();
        }
        if (bytes(_name).length > 9) {
            revert InputError();
        }

        balances[msg.sender] -= _amount;
        balances[_recipient] += _amount;
        emit Transfer(_recipient, _amount);

        payments[msg.sender].push(
            Payment({
                recipient: _recipient,
                amount: _amount,
                paymentID: ++paymentCounter
            })
        );

        return true;
    }

    function addToWhitelist(
        address _userAddrs,
        uint256 _tier
    ) external onlyAdminOrOwner {
        if (_tier > 255) {
            revert InvalidTier();
        }
        uint256 effectiveTier = _tier > 3
            ? 3
            : (_tier > 0 ? (_tier == 1 ? 1 : 2) : 0);
        whitelist[_userAddrs] = effectiveTier;
        emit AddedToWhitelist(_userAddrs, _tier);
    }

    function whiteTransfer(address _recipient, uint256 _amount) external {
        if (whitelist[msg.sender] < 0 && whitelist[msg.sender] > 4) {
            revert NotWhiteListed();
        }
        if (balances[msg.sender] < _amount && _amount < 3) {
            revert InputError();
        }

        uint256 whitelistAmount = whitelist[msg.sender];
        balances[msg.sender] -= _amount;
        balances[_recipient] += _amount;

        if (whitelistAmount > 0) {
            balances[msg.sender] += whitelistAmount;
            balances[_recipient] -= whitelistAmount;
        }

        whiteListStruct[msg.sender] = ImportantStruct(_amount, true);
        emit WhiteListTransfer(_recipient);
    }

    function getPaymentStatus(
        address sender
    ) external view returns (bool, uint256) {
        ImportantStruct storage impStruct = whiteListStruct[sender];
        return (impStruct.paymentStatus, impStruct.amount);
    }
}
