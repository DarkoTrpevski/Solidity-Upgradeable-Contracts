// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import {ERC1155Upgradeable} from "@openzeppelin/contracts-upgradeable/token/ERC1155/ERC1155Upgradeable.sol";
import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

contract MyToken2 is Initializable, ERC1155Upgradeable, OwnableUpgradeable, UUPSUpgradeable {
    // New state variable
    uint256 public maxMintPerTx;

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize(address initialOwner) public initializer {
        __ERC1155_init("");
        __Ownable_init(initialOwner);
        __UUPSUpgradeable_init();
        maxMintPerTx = 10; // New initialization
    }

    function mint(address to, uint256 id, uint256 amount, bytes memory data) public onlyOwner {
        require(amount <= maxMintPerTx, "Exceeds max mint per transaction");
        _mint(to, id, amount, data);
    }

    // New function added in V2
    function setMaxMintPerTx(uint256 _maxMintPerTx) public onlyOwner {
        maxMintPerTx = _maxMintPerTx;
    }

    function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}
}
