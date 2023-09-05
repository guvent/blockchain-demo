// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

interface IERC20 {
    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function allowance(
        address from,
        address to
    ) external view returns (uint256);

    function decimal() external view returns (uint8);

    event Transfer(address indexed from, address indexed to, uint256 amount);

    event Approval(address indexed from, address indexed to, uint256 amount);

    event Mint(address indexed to, uint256 total, uint256 amount);

    event Burn(address indexed from, uint256 total, uint256 amount);
}
