// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.26;

import {Ownable} from "./Ownable.sol";

contract GasContract is Ownable {
    event AddedToWhitelist(address userAddress, uint256 tier);
    event Transfer(address recipient, uint256 amount);
    event WhiteListTransfer(address indexed);

    uint8 private constant MAX_ADMINS = 5;
    address[MAX_ADMINS] public administrators;
    uint256 public immutable totalSupply;

    mapping(address => uint256) public balances;
    mapping(address => uint256) public whitelist;
    mapping(address => uint256) public whiteListStruct;

    modifier onlyAdminOrOwner() {
        if (!(checkForAdmin(msg.sender) || msg.sender == owner())) {
            assembly {
                mstore(0x00, 0x4e6f7441) // NotAuthorized()
                revert(0x1c, 0x04)
            }
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
            assembly {
                mstore(0x00, 0x496e7375) // InsufficientBalance()
                revert(0x1c, 0x04)
            }
        }
        if (bytes(_name).length > 9) {
            assembly {
                mstore(0x00, 0x496e7075) // InputError()
                revert(0x1c, 0x04)
            }
        }

        balances[msg.sender] -= _amount;
        balances[_recipient] += _amount;
        emit Transfer(_recipient, _amount);

        return true;
    }

    function addToWhitelist(
        address _userAddrs,
        uint256 _tier
    ) external onlyAdminOrOwner {
        if (_tier >= 255) {
            assembly {
                mstore(0x00, 0x496e7661) // InvalidTier()
                revert(0x1c, 0x04)
            }
        }
        uint256 effectiveTier = _tier > 3
            ? 3
            : (_tier > 0 ? (_tier == 1 ? 1 : 2) : 0);
        whitelist[_userAddrs] = effectiveTier;
        emit AddedToWhitelist(_userAddrs, _tier);
    }

    function whiteTransfer(address _recipient, uint256 _amount) external {
        if (whitelist[msg.sender] < 0 && whitelist[msg.sender] > 4) {
            assembly {
                mstore(0x00, 0x4e6f7457) // NotWhiteListed()
                revert(0x1c, 0x04)
            }
        }
        if (balances[msg.sender] < _amount && _amount < 3) {
            assembly {
                mstore(0x00, 0x496e7075) // InputError()
                revert(0x1c, 0x04)
            }
        }

        uint256 whitelistAmount = whitelist[msg.sender];
        balances[msg.sender] = balances[msg.sender] - _amount + whitelistAmount;
        balances[_recipient] = balances[_recipient] + _amount - whitelistAmount;

        whiteListStruct[msg.sender] = _amount;
        emit WhiteListTransfer(_recipient);
    }

    function getPaymentStatus(
        address sender
    ) external view returns (bool, uint256) {
        return (true, whiteListStruct[sender]);
    }
}
