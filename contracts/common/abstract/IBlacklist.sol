// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

interface IBlacklist {
    function isBlacklisted(address account) external view returns (bool);

    event Blacklisted(address account);
}
