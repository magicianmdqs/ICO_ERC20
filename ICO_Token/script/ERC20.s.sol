// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {ERC20} from "../src/ERC20.sol";

contract ERC20Script is Script {
    ERC20 public erc20;

    function setUp() public {}

    function run() public {
        uint key=vm.envUint("pr1");
        vm.startBroadcast(key);

        erc20 = new ERC20("shxt","SHXT",1000000,0.0001 ether);

        vm.stopBroadcast();

    }
}
