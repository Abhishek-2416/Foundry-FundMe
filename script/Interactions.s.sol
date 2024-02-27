// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

//Here we are going to have all the ways we can interact with our contract
//Fund
//Withdraw

import {FundMe} from "../src/FundMe.sol";
import {Script} from "forge-std/Script.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol"; //We use this tool to get the most recently deployed contract

contract FundFundMe is Script {
    uint256 constant FUND_VALUE = 0.1 ether;

    function run() external {
        vm.startBroadcast();
        //Here we wont have to always put in the address of the already deployed FundMe contract instead of that here we are using the DevOpsTools and we get the most recently deployed thing
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("FundMe", block.chainid);
        fundFundMe(mostRecentlyDeployed);
        vm.stopBroadcast();
    }

    function fundFundMe(address mostRecentlyDeployed) public {
        FundMe(payable(mostRecentlyDeployed)).fund{value: FUND_VALUE}();
    }
}
