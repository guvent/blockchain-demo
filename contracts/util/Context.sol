// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

abstract contract Context {
    /***** Internal Functions *****/

    function _mSender() internal view returns (address) {
        return msg.sender;
    }

    function _mData() internal pure returns (bytes calldata) {
        return msg.data;
    }

    function _mSignature() internal pure returns (bytes4) {
        return msg.sig;
    }

    function _mValue() internal view returns (uint256) {
        return msg.value;
    }

    function _bTimestamp() internal view returns (uint256) {
        return block.timestamp;
    }

    function _bChainID() internal view returns (uint256) {
        return block.chainid;
    }

    function _bNumber() internal view returns (uint256) {
        return block.number;
    }

    function _bGasLimit() internal view returns (uint256) {
        return block.gaslimit;
    }

    // Since the VM version paris, "difficulty" was replaced by "prevrandao",
    // which now returns a random number based on the beacon chain.solidity(8417)

    // function _bDifficulty() internal view returns (uint) {
    //     return block.difficulty;
    // }
}
