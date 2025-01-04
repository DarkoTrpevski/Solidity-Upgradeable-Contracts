// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import {Script} from "forge-std/Script.sol";

contract Helper is Script {
    function saveDeployment(string memory network, address proxy, address implementation) internal {
        string memory deploymentData = vm.toString(proxy);
        string memory filePath = string.concat("deployments/", network, "/proxy.txt");
        vm.writeFile(filePath, deploymentData);

        deploymentData = vm.toString(implementation);
        filePath = string.concat("deployments/", network, "/implementation.txt");
        vm.writeFile(filePath, deploymentData);
    }

    function getDeploymentAddress(string memory network, string memory contractType) internal view returns (address) {
        string memory filePath = string.concat("deployments/", network, "/", contractType, ".txt");
        try vm.readFile(filePath) returns (string memory data) {
            return vm.parseAddress(data);
        } catch {
            revert("Deployment not found");
        }
    }
}
