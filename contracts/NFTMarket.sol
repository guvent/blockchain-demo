// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "./library/LibOrder.sol";

contract NFTMarket {
    mapping(address => bool) public paymentTokens;

    mapping(address => uint256) public privileges;

    mapping(bytes => uint256) public processedGlobalBids;

    mapping(bytes => OrderStatus) public orderStatus;
    // mapping(address => Royaltier[]) public royalties;

    uint256 public FEE;
    uint256 public maxRoyalty;

    constructor() {}

    function _checkOrderValidity(
        Order memory order,
        bytes memory signature
    ) internal view {
        if (order.end < block.timestamp) {
            // revert OrderExpired();
        }

        // if (order.issuer != verify(order, signature)) {
        //     // revert WrongSignature();
        // }

        if (orderStatus[signature] != OrderStatus.NOT_PROCESSED) {
            // revert AlreadyProcessed();
        }

        if (!paymentTokens[order.paymentToken]) {
            // revert InvalidPaymentToken();
        }
    }

    modifier isOrderValid(Order memory order, bytes memory signature) {
        _checkOrderValidity(order, signature);
        _;
    }
}
