// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/access/AccessControl.sol";

contract Registry is AccessControl {
    bytes32 public constant UPDATER_ROLE = keccak256("UPDATER_ROLE");

  
    mapping(bytes4 => address) private _registry;
    address private _fallback;

    constructor(address admin) {
        _grantRole(DEFAULT_ADMIN_ROLE, admin);
        _grantRole(UPDATER_ROLE, admin);
    }

    function update(bytes4 id, address implementation) external onlyUpdater {
        _registry[id] = implementation;
    }

    function remove(bytes4 id) external onlyUpdater {
        delete _registry[id];
    }

    function getImplementation(bytes4 id) external view returns (address) {
        return _registry[id] != address(0) ? _registry[id] : _fallback;
    }

    modifier onlyUpdater() {
        require(hasRole(UPDATER_ROLE, msg.sender), "Must have updater role to perform this action");
        _;
    }
}
