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

contract InteractionsTest is Test {
    FundMe public fundMe;

    //Creating addresses
    address bob = address(0x1);

    //Constants
    uint256 constant FUND_VALUE = 0.1 ether;
    uint256 constant STARTING_BALANCE = 10 ether;
    uint256 constant GAS_PRICE = 1;

    function setUp() external {
        DeployFundMe deploy = new DeployFundMe();
        fundMe = deploy.run();
        vm.deal(bob, STARTING_BALANCE);
    }

    function testLikeANoob() public view {
        console.log(fundMe.getOwner());
        console.log(msg.sender);
    }

    function testUserCanFundInteractions() public {
        FundFundMe fundFundMe = new FundFundMe();
        fundFundMe.fundFundMe(address(fundMe));

        console.log(fundMe.getAddressToAmountFunded(address(msg.sender)));
        assertEq(fundMe.getAddressToAmountFunded(address(msg.sender)), FUND_VALUE);
    }

    function testUserCanWithdrawInteractions() public {
        FundFundMe fundFundMe = new FundFundMe();
        fundFundMe.fundFundMe(address(fundMe));

        console.log(fundMe.getAddressToAmountFunded(address(msg.sender)));

        WithdrawFundMe withdrawFundMe = new WithdrawFundMe();
        withdrawFundMe.withdrawFundMe(address(fundMe));
    }

    function testUserCanFundAndOwnerWithdraw() public {
        FundFundMe fundFundMe = new FundFundMe();
        fundFundMe.fundFundMe(address(fundMe));

        WithdrawFundMe withdrawFundMe = new WithdrawFundMe();
        withdrawFundMe.withdrawFundMe(address(fundMe));

        assert(address(fundMe).balance == 0);
    }
}
