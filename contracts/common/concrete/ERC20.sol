// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.9;

import "../absract/IERC20.sol";

contract ERC20 is IERC20 {
    string private _name;
    string private _symbol;

    uint256 private _total;

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    function name() public view override returns (string memory) {
        return _name;
    }

    function symbol() public view override returns (string memory) {
        return _symbol;
    }

    function totalSupply() public view override returns (uint256) {
        return _total;
    }

    function balanceOf(address account) public view override returns (uint256) {
        return _balances[account];
    }

    function allowance(
        address from,
        address to
    ) public view override returns (uint256) {
        return _allowances[from][to];
    }

    function decimal() public view virtual override returns (uint8) {
        return 10;
    }

    function _transfer(address from, address to, uint256 amount) internal {
        require(from != address(0), "From address not able zero!");
        require(to != address(0), "To address not able zero!");
        require(amount > 0, "Amount must greater than 0!");

        uint256 fromBalance = _balances[from];
        uint256 newBalance = 0;

        unchecked {
            newBalance = fromBalance - amount;
        }

        require(newBalance >= 0, "Insufficient Balance!");

        _balances[from] = newBalance;
        _balances[to] += amount;
    }

    function _mint(address to, uint256 amount) internal {
        require(to != address(0), "Account not able zero address!");
        require(amount > 0, "Amount must greater than 0!");

        unchecked {
            _total += amount;
            _balances[to] += amount;
        }
    }

    function _burn(address from, uint256 amount) internal {
        require(from != address(0), "Account not able zero address!");
        require(amount > 0, "Amount must greater than 0!");

        require(_total >= amount, "Insufficient token balance!");
        require(_balances[from] >= amount, "Insufficient account balance!");

        uint256 tokenAmount = _total - amount;
        uint256 accountAmount = _balances[from] - amount;

        _total = tokenAmount;
        _balances[from] = accountAmount;
    }

    function _approve(address from, address to, uint256 amount) internal {
        require(from != address(0), "From address not able zero!");
        require(to != address(0), "To address not able zero!");
        // require(amount > 0, "Amount must greater than 0!");

        _allowances[from][to] = amount;
    }

    function _increaseAllowance(address account, uint256 addedValue) internal {
        require(account != address(0), "To address not able zero!");

        _allowances[msg.sender][account] += addedValue;
    }

    function _decreaseAllowance(
        address account,
        uint256 subtractedValue
    ) internal {
        require(account != address(0), "To address not able zero!");
        require(
            _allowances[msg.sender][account] >= subtractedValue,
            "Account don't have allowance!"
        );

        _allowances[msg.sender][account] -= subtractedValue;
    }
}
