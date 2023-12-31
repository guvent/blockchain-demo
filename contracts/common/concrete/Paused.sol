// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "../abstract/IPaused.sol";

abstract contract Paused is IPaused {
    bool private _state;

    /***** Initializers *****/

    constructor() {
        _state = false;
    }

    /***** Internal Functions *****/

    function paused() public view override returns (bool) {
        return _state;
    }

    function _pause() internal {
        _state = true;

        emit Paused(msg.sender);
    }

    function _resume() internal {
        _state = false;

        emit Unpaused(msg.sender);
    }

    /***** Modifiers *****/

    modifier requirePaused() {
        require(_state, "Not Yet Paused!");
        _;
    }

    modifier requireNotPaused() {
        require(!_state, "Token Paused!");
        _;
    }
}
