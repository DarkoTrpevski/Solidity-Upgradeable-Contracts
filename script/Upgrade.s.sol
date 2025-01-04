// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import {Script} from "forge-std/Script.sol";
import {MyToken1} from "../src/MyToken1.sol";
import {MyToken2} from "../src/MyToken2.sol";
import {Helper} from "./Helper.s.sol";
/**
 * forge script script/Upgrade.s.sol --rpc-url http://localhost:8545 --broadcast --sig "run(address)" ERC1967Proxy_CONTRACT_ADDRESS
 * forge script script/Upgrade.s.sol --rpc-url http://localhost:8545 --broadcast --sig "run(address)" 0xe7f1725e7734ce288f8367e1bb143e90bb3f0512
 */

contract UpgradeScript is Script, Helper {
    function run(address proxyAddress) external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address owner = vm.addr(deployerPrivateKey);

        vm.startBroadcast(deployerPrivateKey);

        // Deploy new implementation
        MyToken2 implementation2 = new MyToken2();

        // Upgrade proxy to new implementation
        MyToken1(proxyAddress).upgradeTo(address(implementation2));

        // Initialize the new implementation
        MyToken2(proxyAddress).initialize(owner);

        vm.stopBroadcast();
    }
}
