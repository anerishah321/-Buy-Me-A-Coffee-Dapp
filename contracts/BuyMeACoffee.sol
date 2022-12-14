// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract BuyMeACoffee{
    
    //event to emit when memo is created
    event NewMemo(
        address indexed from,
        uint timestamp,
        string name,
        string message
    );

    //memo struct 
    struct Memo{
        address from;
        uint timestamp;
        string name;
        string message;
    }

    //Adress of contract deployer .marked as payable so that
    //we can withdraw to this address later
    address payable owner;

    //list of all memos recieved from coffee purchaser

    Memo[] memos;

    constructor() {
        //store the address of deployer as a payable address
        //when we withdraw funds we will withdraw here
        owner = payable(msg.sender);
    }
    //@dev get all the memos which is stored 
    //it will be public view and return 
    function getMemos () public view returns(Memo[] memory ){
        return memos;
    }

    /**
    * @dev buy a coffee for owner (sends eth tip and leaves memo)
    * @param _name name of the the coffee purchaser 
    * @param _message a nice message from the purchaser
     */
     //it will be public and payable thats why anyone can buy coffee

     function buyCoffee(string memory _name, string memory _message) public payable {
        //must accept more than 0 eth for a coffee
        require(msg.value > 0, "Can not buy coffee for free!");

        //Add the memo to storage!
        memos.push(Memo(
            msg.sender,
            block.timestamp,
            _name,
            _message
        ));

        //emit NewMemo event with detailes about the memo.
        emit NewMemo(
            msg.sender,
            block.timestamp,
            _name,
            _message
        );
     }

     /**
     *@dev send the entire balance stored in this contract to the owner
      */

      function withdrawTips() public {
        require (owner.send(address(this).balance));
      }
}