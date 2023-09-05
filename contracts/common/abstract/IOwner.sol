// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.9;

interface IOwner {
    function owner() external view returns (address);

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );
}
