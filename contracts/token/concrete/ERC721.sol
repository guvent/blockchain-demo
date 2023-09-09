// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "../../util/Address.sol";
import "../../util/Strings.sol";
import "../abstract/IERC721.sol";
import "../abstract/IERC721Receiver.sol";

contract ERC721 is IERC721 {
    using Address for address;
    using Strings for uint256;

    string private _name;
    string private _symbol;
    string private _uri;

    mapping(uint256 => address) private _owners;
    mapping(address => uint256) private _balances;
    mapping(uint256 => address) private _tokenApprovals;
    mapping(address => mapping(address => bool)) private _operatorApprovals;

    constructor(
        string memory name_,
        string memory symbol_,
        string memory uri_
    ) {
        _name = name_;
        _symbol = symbol_;
        _uri = uri_;
    }

    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function tokenURI(uint256 tokenId) public view returns (string memory) {
        _requireMinted(tokenId);

        string memory baseUri = _baseURI();

        if (bytes(baseUri).length > 0) {
            return string(abi.encodePacked(baseUri, tokenId.toString()));
        }

        return "";
    }

    function _baseURI() internal view returns (string memory) {
        return _uri;
    }

    function balanceOf(
        address owner
    ) public view override returns (uint256 balance) {
        return _balances[owner];
    }

    function ownerOf(
        uint256 tokenId
    ) public view override returns (address owner) {
        return _owners[tokenId];
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public override {
        safeTransferFrom(from, to, tokenId, "");
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes memory data
    ) public override {
        require(
            _isApprovedOrOwner(msg.sender, tokenId),
            "Caller must be token owner or approved!"
        );

        _safeTransfer(from, to, tokenId, data);
    }

    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public override {
        require(
            _isApprovedOrOwner(msg.sender, tokenId),
            "Caller must be token owner or approved!"
        );

        _transfer(from, to, tokenId);
    }

    function approve(address account, uint256 tokenId) public override {
        require(_exists(tokenId), "Token not available on this account!");

        address owner = _ownerOf(tokenId);

        require(
            _ownerOf(tokenId) != account,
            "Don't have this token on this accont!"
        );
        require(msg.sender != owner, "Caller is not token owner!");
        require(
            _isApprovedForAll(owner, msg.sender),
            "Caller is not approved this token!"
        );

        _approve(account, tokenId);
    }

    function setApprovalForAll(
        address operator,
        bool approved
    ) public override {
        require(operator != address(0), "Operator address must not be zero!");
        _setApprovalForAll(msg.sender, operator, approved);
    }

    function getApproved(
        uint256 tokenId
    ) public view override returns (address operator) {
        _requireMinted(tokenId);
        return _tokenApprovals[tokenId];
    }

    function isApprovedForAll(
        address owner,
        address operator
    ) public view override returns (bool) {
        return _isApprovedForAll(owner, operator);
    }

    /*****  Internal Functions *****/

    function _ownerOf(uint256 tokenId) internal view virtual returns (address) {
        return _owners[tokenId];
    }

    function _exists(uint256 tokenId) internal view virtual returns (bool) {
        return _ownerOf(tokenId) != address(0);
    }

    function _transfer(address from, address to, uint256 tokenId) internal {
        require(
            _ownerOf(tokenId) == from,
            "From address must be owner of token!"
        );
        require(to != address(0), "Don't transfer to zero address!");

        require(_balances[from] > 0, "From balance is not enough!");

        delete _tokenApprovals[tokenId];

        unchecked {
            _balances[from] -= 1;
            _balances[to] += 1;
        }

        _owners[tokenId] = to;

        emit Transfer(from, to, tokenId);
    }

    function _safeTransfer(
        address from,
        address to,
        uint256 tokenId,
        bytes memory data
    ) internal {
        _transfer(from, to, tokenId);
        require(
            _checkOnERC721Received(from, to, tokenId, data),
            "Transfer cannot non implemented with ERC721Receiver!"
        );
    }

    function _isApprovedForAll(
        address owner,
        address operator
    ) internal view returns (bool) {
        return _operatorApprovals[owner][operator];
    }

    function _setApprovalForAll(
        address owner,
        address operator,
        bool approved
    ) internal {
        require(operator != owner, "Operator must not be equal with owner!");
        _operatorApprovals[operator][owner] = approved;

        emit ApprovalForAll(owner, operator, approved);
    }

    function _approve(address to, uint256 tokenId) internal {
        _tokenApprovals[tokenId] = to;

        emit Approval(msg.sender, to, tokenId);
    }

    function _isApprovedOrOwner(
        address account,
        uint256 tokenId
    ) internal view returns (bool) {
        address owner = _ownerOf(tokenId);

        return (account == owner ||
            _isApprovedForAll(owner, account) ||
            getApproved(tokenId) == account);
    }

    function _requireMinted(uint256 tokenId) internal view {
        require(_exists(tokenId), "Token must be minted!");
    }

    function _mint(address account, uint256 tokenId) internal {
        require(account != address(0), "Account address must not be zero!");
        require(!_exists(tokenId), "Token has already minted!");

        unchecked {
            _balances[account] += 1;
        }

        _owners[tokenId] = account;

        emit Mint(account, tokenId);
    }

    function _burn(uint256 tokenId) internal {
        address owner = _ownerOf(tokenId);

        if (_balances[owner] > 0) {
            unchecked {
                _balances[owner] -= 1;
            }
        }

        delete _tokenApprovals[tokenId];

        emit Burn(owner, tokenId);
    }

    // Copied From OpenZeppelin Library Contracts (last updated v4.9.0)
    function _checkOnERC721Received(
        address from,
        address to,
        uint256 tokenId,
        bytes memory data
    ) internal virtual returns (bool) {
        if (to.isContract()) {
            try
                IERC721Receiver(to).onERC721Received(
                    msg.sender,
                    from,
                    tokenId,
                    data
                )
            returns (bytes4 retval) {
                return retval == IERC721Receiver.onERC721Received.selector;
            } catch (bytes memory reason) {
                if (reason.length == 0) {
                    revert("Transfer to non ERC721Receiver implementer");
                } else {
                    /// @solidity memory-safe-assembly
                    assembly {
                        revert(add(32, reason), mload(reason))
                    }
                }
            }
        } else {
            return true;
        }
    }
}
