// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title VotingContract
 * @dev A simple smart contract for voting and donations.
 */
contract VotingContract {
    // Struct to represent a candidate
    struct Candidate {
        string name;       // The name of the candidate
        uint voteCount;    // The number of votes received by the candidate
    }

    // Mapping to store candidates with their names as keys
    mapping(string => Candidate) public candidates;

    // Event to log donations
    event DonationReceived(address indexed sender, uint amount);

    /**
     * @dev Constructor to initialize the contract with two candidates, "John" and "Paul".
     */
    constructor() {
        // Initialize candidates with vote count 0
        candidates["John"] = Candidate("John", 0);
        candidates["Paul"] = Candidate("Paul", 0);
    }

    /**
     * @dev Function to allow users to cast a vote for a candidate.
     * @param candidateName The name of the candidate to vote for ("John" or "Paul").
     */
    function vote(string memory candidateName) public onlyValidCandidate(candidateName) {
        // Increase the vote count for the selected candidate
        candidates[candidateName].voteCount++;
    }

    /**
     * @dev Modifier to check if the provided candidate name is valid.
     * Valid names are "John" and "Paul".
     * @param candidateName The name of the candidate to check.
     */
    modifier onlyValidCandidate(string memory candidateName) {
        require(
            keccak256(abi.encodePacked(candidateName)) == keccak256(abi.encodePacked("John")) ||
            keccak256(abi.encodePacked(candidateName)) == keccak256(abi.encodePacked("Paul")),
            "You are not allowed to vote"
        );
        _;
    }

    /**
     * @dev Function to get the current vote count for a candidate and their name.
     * @param candidateName The name of the candidate to check.
     * @return The current vote count and the name of the candidate.
     */
    function getCandidateVoteCount(string memory candidateName) public view onlyValidCandidate(candidateName) returns (uint, string memory) {
        return (candidates[candidateName].voteCount, candidates[candidateName].name);
    }

    /**
     * @dev Function to allow users to send Ether as a donation to the contract.
     */
    receive() external payable {
        // Emit the DonationReceived event with sender's address and the amount received
        emit DonationReceived(msg.sender, msg.value);
    }
}
