// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AuctionSystem {
    address public owner;
    uint public highestBid;
    address public highestBidder;
    bool public isAuctionEnded;

    mapping(address => uint) public bids;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not auction owner.");
        _;
    }

    modifier auctionActive() {
        require(!isAuctionEnded, "Auction already ended.");
        _;
    }

    function placeBid() public payable auctionActive {
        require(msg.value > highestBid, "Bid too low.");

        if (highestBidder != address(0)) {
            bids[highestBidder] += highestBid; // Refund previous highest
        }

        highestBid = msg.value;
        highestBidder = msg.sender;
    }

    function withdraw() public {
        uint amount = bids[msg.sender];
        require(amount > 0, "No funds to withdraw.");
        bids[msg.sender] = 0;
        payable(msg.sender).transfer(amount);
    }

    function endAuction() public onlyOwner auctionActive {
        isAuctionEnded = true;
        payable(owner).transfer(highestBid);
    }
}

