# Proxy Contract for Load Balancing and Function Delegation

## Overview

Design and implement a proxy smart contract that functions as a load balancer for other contracts. It should act as the entry point for all requests, delegating them to specific implementation contracts based on the function requirement.

## Objectives

### Proxy Contract Design

- Create a proxy contract that maintains a registry of implementation addresses for different functionalities (e.g., token transfers, staking, voting).
- Implement a fallback function that takes a function ID as input and delegates the call to the corresponding contract address.

### Function Delegation

- Ensure the proxy contract can forward requests to the appropriate implementation contract along with any necessary data.
- Support updates to implementation addresses without disrupting the proxy contract or requiring redeployment.

### Security and Efficiency

- Incorporate security measures to prevent unauthorized updates to the contract registry.
- Optimize for gas efficiency and minimize execution costs for delegated functions.

## Deployed Contract

Registery Contract - https://sepolia.etherscan.io/address/0x5f12ec6570bb54daef0d63e68208f90cc03d98d1
Staking Contract - https://sepolia.etherscan.io/address/0x82e4a162d720c20ebbe4a731bf1050ec08de5c96#code
Voting Contract - https://sepolia.etherscan.io/address/0xe13f7ce68a050db0d0e7acb83bae1231152b04cc
Token Contract - https://sepolia.etherscan.io/address/0x295eccf308d7c042040b6e6395375e88daff3a2d

## Functionality Implemented

# Voting Contract
This smart contract allows for voting on different candidates. It includes functionalities for voting, registering participants, getting vote counts, and declaring winners.
## Contract Details
- **Owner**: The contract owner who has special privileges.
- **Mappings**:
  - `hasVoted`: Keeps track of whether an address has voted.
  - `votesReceived`: Stores the number of votes received by each candidate.
  - `hasRegisteredParticipant`: Records registered participants for each candidate.
  
## Functions
- `vote(bytes32 candidate, address candidateAddress)`: Allows a participant to vote for a candidate.
- `registerParticipant(bytes32 candidate, address participant, string participantName)`: Registers a participant for a specific candidate.
- `getVoteCount(bytes32 candidate)`: Retrieves the number of votes received by a candidate.
- `declareWinner(bytes32[] candidates)`: Declares the winner based on the maximum number of votes received.
## Events
- `Vote(address indexed voter, bytes32 indexed candidate)`: Triggered when a vote is cast.
- `RegisterParticipant(bytes32 indexed candidate, address indexed participant, string participantName)`: Triggered when a participant is registered.
- `WinnerDeclared(bytes32 indexed winner, uint256 indexed maxVotes)`: Triggered when the winner is declared.
## Modifiers
- `onlyOwner`: Ensures that only the contract owner can execute certain functions.


# Staking Contract

This smart contract allows users to stake tokens for a specified duration and earn rewards based on the staked amount and duration.

## Contract Details

- **Owner**: The contract owner who deploys the contract.
- **Token**: Utilizes a custom token contract `MyToken` for staking and rewards.
- **Time Intervals**: Supports staking durations of 2, 4, 6, 8, or 10 time units.
  
## Functions

- `stakenow(uint amount, uint duration)`: Allows users to stake tokens for a specified duration and earn rewards.
- `calculateReward(uint256 userid)`: Calculates the reward amount based on staking duration and amount.
- `ClaimReward(uint256 userid)`: Allows users to claim their rewards.
- `claimStakedAmount(uint256 userid)`: Allows users to claim their staked amount after the staking duration has passed.
- `ViewDetail(address ads)`: View staking details for a specific address.
- `getBal(address adrs)`: Get the balance of tokens for a specific address.
- `check_duration()`: Get the supported staking durations.
- `chkid(uint id)`: Check stake details by stake ID.

## Events

- `Vote(address indexed voter, bytes32 indexed candidate)`: Triggered when a vote is cast.
- `RegisterParticipant(bytes32 indexed candidate, address indexed participant, string participantName)`: Triggered when a participant is registered.
- `WinnerDeclared(bytes32 indexed winner, uint256 indexed maxVotes)`: Triggered when the winner is declared.

# MyToken Smart Contract
## Overview
The `MyToken` smart contract is an ERC-20 token that extends the functionality of the OpenZeppelin ERC20, ERC20Burnable, AccessControl, and ERC20Permit contracts. It allows for minting tokens, transferring tokens, and managing roles for minter and admin.
## Roles
- **Default Admin Role**: The default admin role is initially granted to the contract deployer. The admin role has permission to manage roles and perform administrative functions.
- **Minter Role**: The minter role is granted to a specified address during contract deployment. The minter role has permission to mint new tokens.
## Functions
- `mint(address to, uint256 amount)`: Allows the minter role to mint a specified amount of tokens and transfer them to a designated address.
- `transfer(address to, uint256 amount)`: Allows token holders to transfer tokens to another address.
- `transferFrom(address from, address to, uint256 amount)`: Allows approved addresses to transfer tokens on behalf of a token holder.
## Modifiers
- `onlyMinter`: Restricts access to functions to only addresses with the minter role.
## Access Control
The contract utilizes the AccessControl OpenZeppelin contract to manage roles and permissions for secure token minting and transfers.

# Registry Smart Contract
## Overview
The `Registry` smart contract is an access-controlled registry that allows for registration, removal, and fallback mechanism for function implementations associated with specific function selectors. The contract uses the AccessControl contract from OpenZeppelin to manage roles and permissions.
## Roles
- **Default Admin Role**: The default admin role is initially granted to the contract deployer and has permission to manage roles.
- **Updater Role**: The updater role is granted to a specified address during contract deployment. The updater role has permission to update, remove, and set fallback implementations.
## Functions
- `update(bytes4 id, address implementation)`: Allows addresses with the updater role to update the implementation for a specific function selector.
- `remove(bytes4 id)`: Allows addresses with the updater role to remove the implementation for a specific function selector.
- `setFallback(address implementation)`: Allows addresses with the updater role to set a fallback implementation.
- `getImplementation(bytes4 id)`: Retrieves the implementation address for a specific function selector.
- `callRegisteredFunction(bytes4 functionId, bytes memory data)`: Executes a registered function on the implementation address using delegatecall.
## Fallback Function
The contract utilizes a fallback function to delegate calls to the appropriate implementation based on the function selector provided.
## Modifiers
- `onlyUpdater`: Restricts access to functions to only addresses with the updater role.


## Requirements

- Dynamic registry of function IDs and corresponding contract addresses.
- Delegation mechanism that supports all types of function calls and data passing.
- Mechanisms for updating, adding, and removing addresses from the registry.

## Points to Considered

- Upgradeability and maintenance of the contract registry.
- Security practices, including role-based access control for registry updates.
- Impact on transaction costs and efficiency when using the proxy for delegation.
- Testing strategies to ensure correct function delegation and execution.
Try running some of the following tasks:

```shell
npx hardhat help
npx hardhat test
REPORT_GAS=true npx hardhat test
npx hardhat node
npx hardhat ignition deploy ./ignition/modules/Lock.js
```
