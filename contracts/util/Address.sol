// SPDX-License-Identifier: MIT
// Copied From OpenZeppelin Library Contracts (last updated v4.9.0)

pragma solidity ^0.8.9;

library Address {
    /***** Internal Functions *****/

    function isContract(address account) internal view returns (bool) {
        return account.code.length > 0;
    }
}
