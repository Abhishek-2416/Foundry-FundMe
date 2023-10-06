// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";


contract FundMeTest is Test{
   FundMe fundMe;

   //So we know that the first function in test should be setUp which is used to deploy our contract
   //This function will deploy our contract,This will be run first before any other function
   function setUp() external{
      // fundMe = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
      //Improvments Now instead of calling the fundMe twice here and int the script we can simply call the deploy function
      DeployFundMe deployFundMe = new DeployFundMe();
      fundMe = deployFundMe.run();
   }

   //This assertEq is a special built in function which is used to check the 2 values given are equal or not
   function testMinimumUSDIsFive() public{
      assertEq(fundMe.MINIMUM_USD(), 5e18);
   }

   function testOwnerIsMsgSender() public{
        //So here we will assume that this should pass through and check if owner is msg.sender but that is not the case here lets see why
        console.log(fundMe.i_owner());
        console.log(msg.sender);
        //Abhove these two will be different valuess
        //This happens because we are the one calling the FundMeTest and then this FundMeTest is calling the FundMe contract
        assertEq(fundMe.i_owner(), msg.sender);
        //So it should be something like this
      //   assertEq(fundMe.i_owner(), address(this));
   }

   function testPriceFeedVersionIsAccurate() public{
      uint version = fundMe.getVersion();
      assertEq(version, 4); //This wont be working as the script will deploy to anvil instead and we have just provided the Sepolia address
   }

}

/*---------------------------------------------------------------------NOTES----------------------------------------------------------------------------------------
What can we do to work with address outside our system ?
So there are 4 type of test
1. Unit
   - Testing a specific part of our code
2. Integration
   - Testing how our code works with other parts of our code 
3. Forked
   - Testing our code in a simulated real enviornment (kinda like uint and integration add on)
4. Staging
   - Testing our code in real enviornemtn that is not production (Protocols skip this and completely get screwed because production envirnemnt is diff)

--> To run a normal test we can type 

    ** forge test -vv 
    Here vv specifies the visibilty of logging

-->This is what we should type if we want to run on sepolia

   ** forge test -vvv --fork-url $SEPOLIA_RPC_URL 

   The downside of doing this is we will create a lot of api calls which is veryyy expensive

--> if we want to see how many lines of our code is actually tested we should type

    ** forge coverage --fork-url $SEPOLIA_RPC_URL


-------------------------------------------------------------------------------------------------------------------------------------------------------------------*/