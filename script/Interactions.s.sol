// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

//Here we are going to have all the ways we can interact with our contract
//Fund
//Withdraw

import {FundMe} from "../src/FundMe.sol";
import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/Script.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol"; //We use this tool to get the most recently deployed contract

/**
 * @title FundFundMe Function Here we are trying to get the contract deploy the FundMe contract and also fund is using the interaction contract
 * @author Abhishek
 * @notice So here we have 2 functions run and fundFundMe where in the
 * fundFundMe this is to fund the contract using the most recently deployed contract
 * run this function is getting the address of the most recently deployed and calling the fundFundMe function with it
 */
contract FundFundMe is Script {
    uint256 constant FUND_VALUE = 0.1 ether;

    function run() external {
        //Here we wont have to always put in the address of the already deployed FundMe contract instead of that here we are using the DevOpsTools and we get the most recently deployed thing
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("FundMe", block.chainid);
        fundFundMe(mostRecentlyDeployed);
    }

    function fundFundMe(address mostRecentlyDeployed) public {
        vm.startBroadcast();
        FundMe(payable(mostRecentlyDeployed)).fund{value: FUND_VALUE}();
        vm.stopBroadcast();
        console.log("Funded FundMe with ", FUND_VALUE);
    }
}

contract WithdrawFundMe is Script {
    uint256 constant FUND_VALUE = 0.1 ether;

    function run() external {
        //Here we wont have to always put in the address of the already deployed FundMe contract instead of that here we are using the DevOpsTools and we get the most recently deployed thing
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("FundMe", block.chainid);
        withdrawFundMe(mostRecentlyDeployed);
    }

    function withdrawFundMe(address mostRecentlyDeployed) public {
        vm.startBroadcast();
        FundMe(payable(mostRecentlyDeployed)).withdraw();
        vm.stopBroadcast();
        console.log("Funded FundMe with ", FUND_VALUE);
    }
}
