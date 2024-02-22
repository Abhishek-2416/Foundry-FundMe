// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {console} from "forge-std/Test.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe public fundMe;

    //This is the default thing and we have to create the function "setUp" before we start writing any test
    function setUp() external {
        //This is how the flow of the contract while testing works

        //We -> FundMeTest -> FundMe , Here we deploy the FundMeTest and this FundMeTest then deploys the FundMe Contract
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
    }

    function testMinimumDollarValue() external {
        uint256 actualValue = fundMe.MINIMUM_USD();
        uint256 expectedValue = 5e18;

        assertEq(actualValue, expectedValue);
    }

    function testOwner() external {
        //We write the below test case direct it will fail as in we will have
        assertEq(fundMe.i_owner(), msg.sender);

        //So here we need to check if the owner is what we expect or not
        // assertEq(fundMe.i_owner(), address(this));
    }

    function testPriceFeedVersionIsAccurate() external {
        //When we run test in Foundry, and we dont specifiy the chain ,It will directly run it in the anvil chain

        //So here we need to add forge test -m testPriceFeedVersionIsAccurate -vvv ---fork-url $SEPOLIA_RPC_URL
        uint256 version = fundMe.getVersion();
        assertEq(version, 4);
    }

    function testFund() external {
        //To make sure the fund FUnction works we need to make sure the getConversionRate works
    }
}
