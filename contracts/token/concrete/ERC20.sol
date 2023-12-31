// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "../abstract/IERC20.sol";

contract ERC20 is IERC20 {
    string private _name;
    string private _symbol;

    uint256 private _total;

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    /***** Initializers *****/

    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    /***** Public Functions *****/

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

    /*****  Internal Functions *****/

    function _transfer(address from, address to, uint256 amount) internal {
        require(from != address(0), "From address not able zero!");
        require(to != address(0), "To address not able zero!");
        require(amount > 0, "Amount must greater than 0!");

        require(_total >= amount, "Insufficient token balance!");
        require(_balances[from] >= amount, "Insufficient account balance!");

        uint256 newBalance = _balances[from] - amount;

        _balances[from] = newBalance;
        _balances[to] += amount;

        emit Transfer(from, to, amount);
    }

    function _mint(address to, uint256 amount) internal {
        require(to != address(0), "Account not able zero address!");
        require(amount > 0, "Amount must greater than 0!");

        _total += amount;
        _balances[to] += amount;

        emit Mint(to, _total, amount);
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

        emit Burn(from, _total, amount);
    }

    function _approve(address from, address to, uint256 amount) internal {
        require(from != address(0), "From address not able zero!");
        require(to != address(0), "To address not able zero!");
        // require(amount > 0, "Amount must greater than 0!");

        _allowances[from][to] = amount;

        emit Approval(from, to, amount);
    }

    function _increaseAllowance(address account, uint256 addedValue) internal {
        require(account != address(0), "To address not able zero!");

        _allowances[msg.sender][account] += addedValue;

        emit Allowance(account, addedValue);
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

        emit Allowance(account, subtractedValue);
    }

    function _transferAllowance(
        address account,
        uint256 subtractedValue
    ) internal {
        require(account != address(0), "To address not able zero!");
        require(
            _allowances[account][msg.sender] >= subtractedValue,
            "Account don't have allowance!"
        );

        _allowances[account][msg.sender] -= subtractedValue;

        emit Allowance(account, subtractedValue);
    }
}
