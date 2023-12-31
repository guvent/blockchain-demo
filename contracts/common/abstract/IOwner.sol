// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

interface IOwner {
    /***** External Functions *****/

    function owner() external view returns (address);

    /***** Events *****/

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );
}
