// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.9;

interface IPaused {
    function paused() external view returns (bool);

    event Paused(address account);

    event Unpaused(address account);
}
