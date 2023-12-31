// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

interface IBlacklist {
    /***** External Functions *****/

    function isBlacklisted(address account) external view returns (bool);

    /***** Events *****/
    event Blacklisted(address account);
}
