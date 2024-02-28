// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {FundMe} from "../src/FundMe.sol";
import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/Script.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployFundMe is Script {
    //We need to start all the deploy contracts with the "run" function
    function run() external returns (FundMe) {
        HelperConfig helperConfig = new HelperConfig();
        address ethUsdPriceFeed = helperConfig.activeNetworkConfig();

        vm.startBroadcast();
        // We will now create a MOCK contract
        FundMe fundMe = new FundMe(ethUsdPriceFeed);
        console.log(address(fundMe.getOwner()));
        console.log(address(fundMe));
        console.log(msg.sender);
        vm.stopBroadcast();
        return fundMe;
    }
}
