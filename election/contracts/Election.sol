pragma solidity ^0.5.0;
//all rights reserved to Amr Ahmed Abd El Rahman
contract Election {

    // Model a Candidate
    struct Candidate {
        uint id;
        string name;
        uint sID;
        string committee;
        uint voteCount;
    }

    // Model a Voter
    struct Voter {
        bool authorized;
        bool voted;
        uint vote;
    }

    // owner of the deployed Smart Contract (Election)
    address public Owner; 

    // store Election name, in my case - BUE Student Union Election
    string public electionName;

    // store total number of votes
    uint public totalVotes;

    // store candidates Count
    uint public candidatesCount;

    // store voter's ballot
    mapping(address => Voter) public voters;

    // Store Candidates
    // Fetch Candidate
    mapping(uint => Candidate) public candidates;

     constructor() public {
        Owner = msg.sender;
        addCandidate("Amr Ahmed Abd El Rahman", 162697, "Scientific");
        addCandidate("Moataz Ahmed Abd El Rahman", 182839, "Clubs");
    }

    // person who is calling this function will be only the Owner of the contract
    modifier ownerOnly(){
        _;
        require(msg.sender == Owner);
    }

    // person who is calling this function is the owner of the contract and will authorize voters to participate in the election
    function authorize(address _person) ownerOnly public {
        voters[_person].authorized = true;
    }

    function addCandidate (string memory _name, uint _UniqueID, string memory _committee) private {
        candidatesCount ++;
        candidates[candidatesCount] = Candidate(candidatesCount, _name, _UniqueID, _committee, 0);
    }

    // return total number of candidates in my system
    function getNumCandidates() public view returns(uint) {
        return candidatesCount;
    }

    // return total number of votes in my system
    function getTotalVotes() public view returns(uint) {
        return totalVotes;
    }

    function setElectionName(string memory _electionName) ownerOnly public{
        electionName = _electionName;
    }

    // the most important function - casting a vote
    function vote (uint _candidateId) public {

        // require that they haven't voted before
        require(!voters[msg.sender].voted);

        // require voter to be authorized by the owner of the contract
        require(voters[msg.sender].authorized == true);

        // require a valid candidate
        require(_candidateId > 0 && _candidateId <= candidatesCount);

        // record that voter has voted
        voters[msg.sender].voted = true;

        // store voter choice
        voters[msg.sender].vote = _candidateId;

        // update candidate vote count
        candidates[_candidateId].voteCount ++;

        // incrementing the total number of votes
        totalVotes++;
    }
    
}
//all rights reserved to Amr Ahmed Abd El Rahman