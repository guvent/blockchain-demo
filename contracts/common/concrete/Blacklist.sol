// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.9;

import "../abstract/IBlacklist.sol";

contract Blacklist is IBlacklist {
    mapping(address => bool) private _blacklist;

    function isBlacklisted(
        address account
    ) public view override returns (bool) {
        return _blacklist[account];
    }

    function _isBlacklistedTwice(
        address from,
        address to
    ) internal view returns (bool) {
        return _blacklist[from] || _blacklist[to];
    }

    function _blacklistAccount(address account, bool value) internal {
        _blacklist[account] = value;

        emit Blacklisted(account);
    }

    modifier checkSenderBlacklist() {
        require(!isBlacklisted(msg.sender), "Account Blocked!");
        _;
    }
}
