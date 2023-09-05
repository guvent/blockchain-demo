// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "../abstract/IOwner.sol";

abstract contract Owner is IOwner {
    address private _owner;

    constructor() {
        _transferOwnership(msg.sender);
    }

    function owner() public view override returns (address) {
        return _owner;
    }

    function _checkOwner() internal view returns (bool) {
        return _owner == msg.sender;
    }

    function _transferOwnership(address newOwner) internal returns (address) {
        address oldOwner = _owner;
        _owner = newOwner;

        emit OwnershipTransferred(oldOwner, newOwner);

        return oldOwner;
    }

    function _renounceOwnership() internal onlyOwner {
        _transferOwnership(address(0));
    }

    modifier onlyOwner() {
        require(_checkOwner(), "Caller is not owner!");
        _;
    }
}
