// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

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

    function setFallback(address implementation) external onlyUpdater {
        _fallback = implementation;
    }

    function getImplementation(bytes4 id) public view returns (address) {
        return _registry[id] != address(0) ? _registry[id] : _fallback;
    }
    
        
    fallback() external {
        address implementation = _registry[msg.sig];
        require(implementation != address(0), "Function implementation not found");
        
        assembly {
            // Load the first 32 bytes of the call data containing the function selector
            let functionSelector := calldataload(0)
          
            calldatacopy(0, 4, sub(calldatasize(), 4))
            
            let success := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
           
            if eq(success, 0) {
                revert(0, 0)
            }
            // Get the return data
            returndatacopy(0, 0, returndatasize())
            // Return the return data
            return(0, returndatasize())
        }
    }
    

    function callRegisteredFunction(bytes4 functionId, bytes memory data) external returns (bool, bytes memory) {
        address implementation = getImplementation(functionId);
        require(implementation != address(0), "Function implementation not found");

        // Perform delegatecall to execute the function on the implementation address
      (bool success, bytes memory result) = implementation.delegatecall(abi.encodePacked(functionId, data));
        return (success, result);
    }

    modifier onlyUpdater() {
        require(hasRole(UPDATER_ROLE, msg.sender), "Must have updater role to perform this action");
        _;
    }
}