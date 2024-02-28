// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Vm} from "forge-std/Vm.sol";
import {Test} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {console} from "forge-std/Test.sol";
import {HelperConfig} from "../../script/HelperConfig.s.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe public fundMe;
    HelperConfig public helperConfig;

    //Creating addresses
    address bob = address(0x1);

    //Constants
    uint256 constant FUND_VALUE = 0.2 ether;
    uint256 constant STARTING_BALANCE = 10 ether;
    uint256 constant GAS_PRICE = 1;

    modifier funded() {
        vm.prank(bob);
        fundMe.fund{value: FUND_VALUE}();
        _;
    }

    //This is the default thing and we have to create the function "setUp" before we start writing any test
    function setUp() external {
        //This is how the flow of the contract while testing works

        //We -> FundMeTest -> FundMe , Here we deploy the FundMeTest and this FundMeTest then deploys the FundMe Contract
        DeployFundMe deployFundMe = new DeployFundMe();
        (fundMe, helperConfig) = deployFundMe.run();

        vm.deal(bob, STARTING_BALANCE);
    }

    function testMinimumDollarValue() external {
        uint256 actualValue = fundMe.MINIMUM_USD();
        uint256 expectedValue = 5e18;

        assertEq(actualValue, expectedValue);
    }

    function testOwner() external {
        //We write the below test case direct it will fail as in we will have
        assertEq(fundMe.getOwner(), msg.sender);

        //So here we need to check if the owner is what we expect or not
        // assertEq(fundMe.i_owner(), address(this));
    }

    function testPriceFeedVersionIsAccurate() external {
        //When we run test in Foundry, and we dont specifiy the chain ,It will directly run it in the anvil chain

        //So here we need to add forge test -m testPriceFeedVersionIsAccurate -vvv ---fork-url $SEPOLIA_RPC_URL
        uint256 version = fundMe.getVersion();
        assertEq(version, 4);
    }

    function testFundFailsWithoutEnoughETH() external {
        //Here we are sending zero value and seeing if the function fails when less is sent
        vm.expectRevert();
        fundMe.fund();
    }

    function testFundUpdatesFundedDataStructure() public {
        vm.prank(bob);
        fundMe.fund{value: FUND_VALUE}();

        assertEq(fundMe.getAddressToAmountFunded(bob), FUND_VALUE);
    }

    function testAddsFunderToArrayOfFunders() public {
        vm.prank(bob);
        fundMe.fund{value: FUND_VALUE}();

        address funder = fundMe.getFunder(0);
        assertEq(funder, bob);
    }

    function testOnlyOwnerCanWithdraw() public funded {
        vm.prank(bob);
        vm.expectRevert();
        fundMe.withdraw();
    }

    function testWithdrawWithASingleFunder() public funded {
        /**
         * Here we are going to go with the Arrange Act and Assert method
         */

        //Arrange

        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        //Act
        uint256 gasStart = gasleft();
        vm.txGasPrice(GAS_PRICE);
        vm.prank(fundMe.getOwner());
        fundMe.withdraw();

        uint256 gasEnd = gasleft();
        uint256 gasUsed = (gasStart - gasEnd) * tx.gasprice;
        console.log(gasUsed);

        //Assert
        uint256 endingOwnerBalance = fundMe.getOwner().balance;
        uint256 endingFundMeBalance = address(fundMe).balance;

        assertEq(startingOwnerBalance + FUND_VALUE, endingOwnerBalance);
        assertEq(startingFundMeBalance - FUND_VALUE, endingFundMeBalance);
    }

    function testWithdrawWithMultipleFunders() public funded {
        //Arrange
        uint160 numberOfFunders = 10;
        uint160 startingFunderIndex = 1;
        for (uint160 i = startingFunderIndex; i < numberOfFunders; i++) {
            hoax(address(i), STARTING_BALANCE);
            fundMe.fund{value: FUND_VALUE}();
        }

        uint256 startingOwnerBalance = fundMe.getOwner().balance;

        //Act
        vm.startPrank(fundMe.getOwner());
        fundMe.withdraw();
        vm.stopPrank();

        //Assert
        uint256 endingOwnerBalance = fundMe.getOwner().balance;
        uint256 endingFundMeBalance = address(fundMe).balance;

        assertEq(endingFundMeBalance, 0);
        assertEq(endingOwnerBalance, startingOwnerBalance + (FUND_VALUE * numberOfFunders));
    }

    function testOnlyOwnerCanDoCheaperWithdraw() public funded {
        //Arrange
        uint160 numberOfFunders = 10;
        uint160 startingFunderIndex = 1;
        for (uint160 i = startingFunderIndex; i < numberOfFunders; i++) {
            hoax(address(i), STARTING_BALANCE);
            fundMe.fund{value: FUND_VALUE}();
        }

        uint256 startingOwnerBalance = fundMe.getOwner().balance;

        //Act
        vm.startPrank(fundMe.getOwner());
        fundMe.cheaperWithdraw();
        vm.stopPrank();

        //Assert
        uint256 endingOwnerBalance = fundMe.getOwner().balance;
        uint256 endingFundMeBalance = address(fundMe).balance;

        assertEq(endingFundMeBalance, 0);
        assertEq(endingOwnerBalance, startingOwnerBalance + (FUND_VALUE * numberOfFunders));
    }
}
