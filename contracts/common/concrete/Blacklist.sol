// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "../abstract/IBlacklist.sol";

contract Blacklist is IBlacklist {
    mapping(address => bool) private _blacklist;

    /***** Public Functions *****/

    function isBlacklisted(
        address account
    ) public view override returns (bool) {
        return _blacklist[account];
    }

    /***** Internal Functions *****/

    function _isBlacklistedTwice(
        address from,
        address to
    ) internal view returns (bool) {
        if (_blacklist[from]) return true;
        if (_blacklist[to]) return true;
        return false;
    }

    function _blacklistAccount(address account, bool value) internal {
        _blacklist[account] = value;

        emit Blacklisted(account);
    }

    /***** Modifiers *****/

    modifier checkSenderBlacklist() {
        require(!isBlacklisted(msg.sender), "Sender Account Blocked!");
        _;
    }
}
