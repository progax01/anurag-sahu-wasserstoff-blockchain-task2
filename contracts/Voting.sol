// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract Voting {
    mapping(address => bool) public hasVoted;
    mapping(bytes32 => uint256) public votesReceived;
    mapping(bytes32 => mapping(address => bool)) public hasRegisteredParticipant; // Mapping of registered participants

    address public owner;

    event Vote(address indexed voter, bytes32 indexed candidate);
    event RegisterParticipant(bytes32 indexed candidate, address indexed participant, string participantName); // Include participant name in event
    event WinnerDeclared(bytes32 indexed winner, uint256 indexed maxVotes);
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Only contract owner can call this function");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function vote(bytes32 candidate,address candidateAddress) public {
        require(!hasVoted[msg.sender], "Voter has already voted");
        require(hasRegisteredParticipant[candidate][candidateAddress], "Participant is not registered for this candidate");
        hasVoted[msg.sender] = true;
        votesReceived[candidate]++;
        emit Vote(msg.sender, candidate);
    }

    function registerParticipant(bytes32 candidate, address participant, string memory participantName) public onlyOwner {
        require(candidate != bytes32(0), "Candidate name cannot be empty");
        require(participant != address(0), "Participant address cannot be zero");
        require(!hasRegisteredParticipant[candidate][participant], "Participant already registered");

        hasRegisteredParticipant[candidate][participant] = true;
        emit RegisterParticipant(candidate, participant, participantName);
    }

    function getVoteCount(bytes32 candidate) public view returns (uint256) {
        return votesReceived[candidate];
    }

   function declareWinner(bytes32[] memory candidates) public onlyOwner {
    require(candidates.length > 0, "At least one candidate must be provided");

    bytes32 winner;
    uint256 maxVotes = 0;

    for (uint256 i = 0; i < candidates.length; i++) {
        if (votesReceived[candidates[i]] > maxVotes) {
            winner = candidates[i];
            maxVotes = votesReceived[candidates[i]];
        }
    }

    emit WinnerDeclared(winner, maxVotes);
}

}
