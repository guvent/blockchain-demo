// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

interface IPaused {
    /***** External Functions *****/

    function paused() external view returns (bool);

    /***** Events *****/

    event Paused(address account);

    event Unpaused(address account);
}
