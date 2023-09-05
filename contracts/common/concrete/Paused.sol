// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.9;

import "../absract/IPaused.sol";

abstract contract Paused is IPaused {
    bool private _state;

    constructor() {
        _state = false;
    }

    function paused() public view override returns (bool) {
        return _state;
    }

    function _pause() internal {
        _state = true;
    }

    function _resume() internal {
        _state = false;
    }

    modifier requirePaused() {
        require(_state, "Not yet paused!");
        _;
    }

    modifier requireNotPaused() {
        require(!_state, "Not yet paused!");
        _;
    }
}
