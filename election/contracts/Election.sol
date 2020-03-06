pragma solidity ^0.5.0;
//all rights reserved to Amr Ahmed Abd El Rahman
contract Election {
    // Model a Candidate
    struct Candidate {
        uint id;
        string name;
        uint voteCount;
    }
    // Model a Voter
    struct Voter {
        bool authorized;
        bool voted;
        uint vote;
    }

    //Owner of the deployed Smart Contract(Election)
    address public Owner; 

    // Store Election name, in my case - BUE Student Union Election
    string public electionName;

    // Store total number of votes
    uint public totalVotes;

    // Store Candidates Count
    uint public candidatesCount;

    // Store Voter's Ballot
    mapping(address => Voter) public voters;

    // Store Candidates
    // Fetch Candidate
    mapping(uint => Candidate) public candidates;

     constructor() public {
        Owner = msg.sender;
        addCandidate("Amr Ahmed Abd El Rahman");
        addCandidate("Moataz Ahmed Abd El Rahman");
    }

    // Person who is calling this function will be only the Owner of the contract
    modifier ownerOnly(){
        _;
        require(msg.sender == Owner);
    }

    function authorize(address _person) ownerOnly public {
        voters[_person].authorized = true;
    }

    function addCandidate (string memory _name) private {
        candidatesCount ++;
        candidates[candidatesCount] = Candidate(candidatesCount, _name, 0);
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

        // update candidate vote Count
        candidates[_candidateId].voteCount ++;

        // incrementing Votes
        totalVotes++;
    }
    
}
//all rights reserved to Amr Ahmed Abd El Rahman