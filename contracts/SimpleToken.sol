// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "./util/Context.sol";
import "./token/concrete/ERC20.sol";
import "./common/concrete/Owner.sol";
import "./common/concrete/Blacklist.sol";
import "./common/concrete/Paused.sol";

contract SimpleToken is ERC20, Context, Owner, Blacklist, Paused {
    mapping(address => uint) time;

    constructor() ERC20("Simple Token", "SIMPLET") {}

    function mint(address to, uint amount) public onlyOwner {
        _mint(to, amount);
    }

    function burn(uint amount) public onlyOwner {
        _burn(_mSender(), amount);
    }

    function approve(address to, uint256 amount) public {
        address from = _mSender();

        require(!_isBlacklistedTwice(from, to), "Account Blocked!");

        _approve(from, to, amount);
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public requireNotPaused {
        address spender = _mSender();

        require(
            allowance(from, spender) >= amount,
            "Account don't have allowance!"
        );
        require(!_isBlacklistedTwice(from, to), "Account Blocked!");

        _transfer(from, to, amount);
        _decreaseAllowance(spender, amount);
    }

    function transferTo(address to, uint256 amount) public requireNotPaused {
        address from = _mSender();

        require(!_isBlacklistedTwice(from, to), "Account Blocked!");

        _transfer(from, to, amount);
    }

    function increaseAllowance(
        address account,
        uint256 addedValue
    ) public checkSenderBlacklist {
        require(!isBlacklisted(account), "Account Blocked!");

        _increaseAllowance(account, addedValue);
    }

    function decreaseAllowance(
        address account,
        uint256 subtractedValue
    ) public checkSenderBlacklist {
        require(!isBlacklisted(account), "Account Blocked!");

        _decreaseAllowance(account, subtractedValue);
    }

    function blacklistAccount(address account) public onlyOwner {
        require(!_checkOwner(), "The owner cannot block itself!");

        _blacklistAccount(account, true);
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _resume();
    }
}
