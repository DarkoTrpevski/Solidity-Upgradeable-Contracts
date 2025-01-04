// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import {Script} from "forge-std/Script.sol";
import {MyToken1} from "../src/MyToken1.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

/**
 * forge script script/Deploy.s.sol --rpc-url http://localhost:8545 --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 --broadcast
 */
contract DeployScript is Script {
    function run() external returns (address proxy, address implementation) {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address owner = vm.addr(deployerPrivateKey);

        vm.startBroadcast(deployerPrivateKey);

        // Deploy implementation
        MyToken1 implementation1 = new MyToken1();

        // Prepare initialization data
        bytes memory initData = abi.encodeWithSelector(MyToken1.initialize.selector, owner);

        // Deploy proxy
        ERC1967Proxy proxy_ = new ERC1967Proxy(address(implementation1), initData);

        vm.stopBroadcast();

        return (address(proxy_), address(implementation1));
    }
}
