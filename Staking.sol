// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./Token.sol";

/** 
@title Staking Contract
@author Anurag Sahu
@notice Explain to an end user what this does
@dev Explain to a developer any extra details
*/

contract MyStakingContract {
    uint256 private tokenIdCounter;
    MyToken public immutable token;
    address public immutable owner;
    uint256[] time = [2, 4, 6, 8, 10];

    constructor(MyToken _token) {
        token = MyToken(_token);
        owner = msg.sender;
    }

    struct Stake {
        uint256 tokenIdc;
        uint256 amount;
        uint256 duration;
        uint256 startTime;
        address userads;
        bool isClaimed;
        bool isAmountc;
    }
  
    mapping(address => Stake[]) public userStakes; 
    mapping(uint => Stake) public cid;
      
    function getBal(address adrs) public view returns (uint256) {
        return token.balanceOf(adrs);
    }

    function stakenow(uint amount, uint duration ) public returns (Stake memory ){
        
        require(amount > 0, "Amount must be greater than zero");

        require( duration == 2 || duration == 4 || duration == 6 || duration == 8 || duration == 10,
            "Enter Duration in formate check duration" );

        tokenIdCounter++;
        Stake memory newStake = Stake(tokenIdCounter, amount, duration, block.timestamp, msg.sender,false,false);
        userStakes[msg.sender].push(newStake);
        token.transferFrom(msg.sender, address(this), amount);
        cid[tokenIdCounter]=newStake;
        return newStake;
    } 
    
    function check_duration() public view returns (uint256[] memory) {
        return time;
    }

    function chkid(uint id) public view returns(Stake memory){
        return cid[id];
    }

    function ViewDetail(address ads) public view returns (Stake[] memory) {
        return userStakes[ads];
    }

    function calculateReward(uint256 userid) public view returns (address,uint256, uint256, uint256)
    {
        uint256 endTime = block.timestamp;

        uint256 duration = endTime -  cid[userid].startTime;
        if (duration >  cid[userid].duration * 60) {
            duration = cid[userid].duration * 60;
        }

        // You can define your own reward mechanism here.
        // For example, a simple linear reward of 1 token per second.
        uint256 reward = duration * 1;

        return (cid[userid].userads, cid[userid].tokenIdc, reward, (reward +  cid[userid].amount));
    }

    function ClaimReward(uint256 userid) public {
        require(msg.sender == cid[userid].userads, "You can only claim your own rewards");
        require(!cid[userid].isClaimed, "Reward already claimed");

        // Mark the stake as claimed
        cid[userid].isClaimed = true;

        (address userAddress, uint256 tokenId, uint256 reward, uint256 totalAmount) = calculateReward(userid);

        // Transfer the reward tokens to the user
        bool success = token.transfer(userAddress, reward);
        require(success, "Token transfer failed");
    }

    function claimStakedAmount(uint256 userid) public {
        require(msg.sender == cid[userid].userads, "You can only claim your own staked amount");
        require(!cid[userid].isAmountc, "Reward already claimed your amount");
        require(block.timestamp >= cid[userid].startTime + cid[userid].duration * 1 minutes, "You can only claim after the staking duration has passed");

        // Mark the stake as claimed
        cid[userid].isAmountc = true;

        (address userAddress, uint256 tokenId, uint256 reward, uint256 Amount) = calculateReward(userid);

        uint256 stakedAmount = cid[userid].amount; // Store the staked amount in a local variable
        cid[userid].amount = 0; // Reset the staked amount in the contract

        // Transfer the staked amount back to the user
        bool success = token.transfer(userAddress, stakedAmount);
        require(success, "Token transfer failed");
    }
}
