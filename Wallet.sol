// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract MyWallet {

    struct History {
        address sender;
        uint256 amount;
        uint256 time;
        string tx_type;
    }
    

    // Mapping to store an array of History structs for each address
    mapping(address => History[]) public transactionHistory;

    // State variable

    address private owner;

    constructor () {

        owner = msg.sender;

    }

    function send_money(address to, uint256 amount) public {

        require(msg.sender == owner, "You are not the wallet owner");

        uint256 balance = address(this).balance;

        require(amount <= balance, "Insufficient amount");

        payable(to).transfer(amount);

        //Recording Sender history
        transactionHistory[owner].push(History(
                owner, amount, block.timestamp, "Sent"
        ));

        //Recording in Receivers history
        transactionHistory[to].push(History(
                owner, amount, block.timestamp, "Received"
        ));

    }

    function receive_money() public payable {

        require(msg.value > 0);

        //Recording Receiving history
        transactionHistory[msg.sender].push(History(
                msg.sender, msg.value, block.timestamp, "Received"
        ));

    }

    function withdraw( uint256 amount) public {

        require(msg.sender == owner, "You are not the wallet owner");

        uint256 balance = address(this).balance;

        require(amount <= balance, "Insufficient amount");

        payable(owner).transfer(amount);
        
        //Recording withdrawn history
        transactionHistory[owner].push(History(
                owner, amount, block.timestamp, "Withdrawn"
        ));

    }

    //Function to return the transaction history for a specific address 
     function getTransactionHistory(address _address) public view returns (History[] memory) {
        return transactionHistory[_address];
    }

    function getBalance() public view returns (uint256) {

        return address(this).balance;

    }   

}
