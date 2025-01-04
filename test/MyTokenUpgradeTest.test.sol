// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import {Test} from "forge-std/Test.sol";
import {MyToken1} from "../src/MyToken1.sol";
import {MyToken2} from "../src/MyToken2.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract MyTokenUpgradeTest is Test {
    MyToken1 public implementation1;
    MyToken2 public implementation2;

    ERC1967Proxy public proxy;

    MyToken1 public proxyAsMyToken1;
    MyToken2 public proxyAsMyToken2;
    
    address owner = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;

    function setUp() public {
        // Deploy implementation contracts
        implementation1 = new MyToken1();
        implementation2 = new MyToken2();

        // Deploy proxy contract pointing to implementation1
        bytes memory initData = abi.encodeWithSelector(MyToken1.initialize.selector, owner);
        proxy = new ERC1967Proxy(address(implementation1), initData);

        // Create proxy wrappers
        proxyAsMyToken1 = MyToken1(address(proxy));
        proxyAsMyToken2 = MyToken2(address(proxy));
    }

    function testInitialState() public view {
        assertEq(proxyAsMyToken1.owner(), owner);
    }

    function testUpgrade() public {
        // Test minting before upgrade
        vm.startPrank(owner);
        proxyAsMyToken1.mint(address(2), 1, 100, "");
        assertEq(proxyAsMyToken1.balanceOf(address(2), 1), 100);

        // Upgrade to implementation2
        proxyAsMyToken1.upgradeTo(address(implementation2));

        // Test new functionality
        proxyAsMyToken2.setMaxMintPerTx(5);
        assertEq(proxyAsMyToken2.maxMintPerTx(), 5);

        // Test that old data persists
        assertEq(proxyAsMyToken2.balanceOf(address(2), 1), 100);

        // Test new mint restriction
        vm.expectRevert("Exceeds max mint per transaction");
        proxyAsMyToken2.mint(address(2), 2, 6, "");

        // Test successful mint within new limits
        proxyAsMyToken2.mint(address(2), 2, 5, "");
        assertEq(proxyAsMyToken2.balanceOf(address(2), 2), 5);
        vm.stopPrank();
    }
}
