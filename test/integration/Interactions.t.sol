// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

/**
 * @title Integration Tests
 * @author Abhishek Alimchandani
 * @notice The main purpose of this testing is to see if we are able to test the contract with external calls
 * As we have written function for fund and withdraw in the Interaction.s.sol we are here to test it
 */
import {Vm} from "forge-std/Vm.sol";
import {Test} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {console} from "forge-std/Test.sol";
import {FundFundMe} from "../../script/Interactions.s.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {WithdrawFundMe} from "../../script/Interactions.s.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";

contract InteractionsTest is Test {
    FundMe public fundMe;
    DeployFundMe public deploy;

    //Creating addresses
    address bob = address(0x1);
    address boss = address(0x5b73C5498c1E3b4dbA84de0F1833c4a029d90519);

    //Constants
    uint256 constant FUND_VALUE = 5 ether;
    uint256 constant STARTING_BALANCE = 10 ether;
    uint256 constant GAS_PRICE = 1;

    function setUp() external {
        deploy = new DeployFundMe();
        (fundMe) = deploy.run();
        vm.deal(bob, STARTING_BALANCE);
    }

    function testUserCanFundInteractions() public {
        FundFundMe fundFundMe = new FundFundMe();
        fundFundMe.fundFundMe(address(fundMe));

        console.log(fundMe.getAddressToAmountFunded(address(msg.sender)));
        assertEq(fundMe.getAddressToAmountFunded(address(fundMe.getOwner())), FUND_VALUE);
    }

    function testUserCanFundAndOwnerWithdraw() public {
        console.log(boss.balance);
        FundFundMe fundFundMe = new FundFundMe();
        fundFundMe.fundFundMe(address(fundMe));

        console.log(boss.balance);

        WithdrawFundMe withdrawFundMe = new WithdrawFundMe();
        withdrawFundMe.withdrawFundMe(address(fundMe));

        console.log(boss.balance);
    }
}
