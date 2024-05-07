// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";
import "./Registry.sol";

contract ProxyImplementation  {
    Registry private registry;

    constructor( address _registry) {
        registry = Registry(_registry);
    }

    receive() external payable {}

    function _fallback() internal  {
        address implementation = registry.getImplementation(msg.sig);
        require(implementation != address(0), "Implementation not found");
        (bool success, ) = implementation.delegatecall(msg.data);
        require(success, "Forwarding call failed");
    }

    function updateRegistry(address _registry) external {
        registry = Registry(_registry);
    }

      function callRegisteredFunction(bytes4 functionId, bytes memory data) external returns (bool, bytes memory) {
        address implementation = registry.getImplementation(functionId);
        require(implementation != address(0), "Function implementation not found");

        // Perform delegatecall to execute the function on the implementation address
        (bool success, bytes memory result) = implementation.delegatecall(data);
        return (success, result);
    }
}
