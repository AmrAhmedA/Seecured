pragma solidity ^0.5.0;
//all rights reserved to Amr Ahmed Abd El Rahman
contract Election {
    // Model a Candidate
    struct Candidate {
        uint id;
        string name;
        uint voteCount;
    }
    // Store Election name, in my case - BUE Student Union Election
    string public electionName;

    // Store total number of votes
    uint public totalVotes;

    // Store Candidates Count
    uint public candidatesCount;

    // Store accounts that have voted
    mapping(address => bool) public voters;
    // Store Candidates
    // Fetch Candidate
    mapping(uint => Candidate) public candidates;

     constructor() public {
        addCandidate("Amr Ahmed Abd El Rahman");
        addCandidate("Moataz Ahmed Abd El Rahman");
    }

    function addCandidate (string memory _name) private {
        candidatesCount ++;
        candidates[candidatesCount] = Candidate(candidatesCount, _name, 0);
    }

    function vote (uint _candidateId) public {
        // require that they haven't voted before
        require(!voters[msg.sender]);

        // require a valid candidate
        require(_candidateId > 0 && _candidateId <= candidatesCount);

        // record that voter has voted
        voters[msg.sender] = true;

        // update candidate vote Count
        candidates[_candidateId].voteCount ++;

        // incrementing Total Number of Votes
        totalVotes++;
    }
    
    // return total number of candidates in my system
    function getNumCandidates() public view returns(uint) {
        return candidatesCount;
    }

    // return total number of votes in my system
    function getTotalVotes() public view returns(uint) {
        return totalVotes;
    }
}
//all rights reserved to Amr Ahmed Abd El Rahman