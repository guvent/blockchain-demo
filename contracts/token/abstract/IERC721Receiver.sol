// SPDX-License-Identifier: MIT
// Copied From OpenZeppelin Library Contracts (last updated v4.9.0)

pragma solidity ^0.8.9;

interface IERC721Receiver {
    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external returns (bytes4);
}
