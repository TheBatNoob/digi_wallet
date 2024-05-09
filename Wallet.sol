// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

contract Wallet{
   
    address public owner;
    uint256 private balance;

    // Constructor function
    constructor() {
        owner = msg.sender;
        balance = 0;
    }

    // Function to receive funds
    receive() external payable {
         balance += msg.value;
    }

    // Function to send funds to an external account
    function send(address payable recipient, uint256 amount) public {
        recipient.transfer(amount);
    }

    // Function to withdraw funds to the owner's personal account
    function withdraw(uint256 amount) public {

        (bool callSuccess, ) = payable(msg.sender).call{value: amount}("");
        require(callSuccess, "Call failed");
    }

    // Function to check the balance of the contract
    function getBalance() public view returns (uint256) {
        return balance;
    }
}

