pragma solidity ^0.5.0;


//all rights reserved to Amr Ahmed Abd El Rahman
contract Election {
    // Model a Candidate
    struct Candidate {
        uint256 id;
        string name;
        uint256 sID;
        string committee;
        uint256 voteCount;
    }

    // Model a Voter
    struct Voter {
        bool authorized;
        bool voted;
        uint256 vote;
    }

    // Owner of the deployed smart contract (Election)
    address public Owner;

    // Store election name, in my case - BUE Student Union Election
    string public electionName;

    // Store election end-date
    string public electionDate;

    // Store total number of votes
    uint256 public totalVotes;

    // Store candidates count
    uint256 public candidatesCount;

    // Store winner name
    string public electionWinner;

    // Store voter's ballot
    mapping(address => Voter) public voters;

    // Store Candidates
    // Fetch Candidate
    mapping(uint256 => Candidate) public candidates;

    constructor() public {
        Owner = msg.sender;
        addCandidate("Amr Ahmed Abd El Rahman", 162697, "Scientific");
        addCandidate("Moataz Ahmed Abd El Rahman", 182839, "Clubs");
        setElectionName("BUE Student Union Election");
        setElectionEndDate("08/25/2020");
    }

    // Person who is calling this function will be only the Owner of the contract
    modifier ownerOnly() {
        _;
        require(msg.sender == Owner, "Caller is not owner");
    }

    // handling user vote through indexed event
    event votedEvent(uint256 indexed _candidateId);

    // handling winner announcing event 
    event winnerEvent();

    // handling ending election event 
    event endElection();

    // Person who is calling this function is the owner of the contract and will authorize voters to participate in the election
    function authorize(address _person) public ownerOnly {
        voters[_person].authorized = true;
    }

    function addCandidate(
        string memory _name,
        uint256 _UniqueID,
        string memory _committee
    ) public ownerOnly {
        candidatesCount++;
        candidates[candidatesCount] = Candidate(
            candidatesCount,
            _name,
            _UniqueID,
            _committee,
            0
        );
    }

    function setElectionName(string memory _electionName) public ownerOnly {
        electionName = _electionName;
    }

    function setElectionEndDate(string memory _electionDate) public ownerOnly {
        electionDate = _electionDate;
    }

    // Return total number of candidates
    function getNumCandidates() public view returns (uint256) {
        return candidatesCount;
    }

    // Return total number of votes
    function getTotalVotes() public view returns (uint256) {
        return totalVotes;
    }

    // Return Contract Owner Address
    function getOwner() external view returns (address) {
        return Owner;
    }

    // The most important function - casting a vote
    function vote(uint256 _candidateId) public {
        // Require that they haven't voted before
        require(!voters[msg.sender].voted, "User has voted before");

        // Require voter to be authorized by the owner of the contract
        require(
            voters[msg.sender].authorized == true,
            "User is not eligable to participate in the voting process"
        );

        // Require a valid candidate
        require(
            _candidateId > 0 && _candidateId <= candidatesCount,
            "Candidate selection is invalid"
        );

        // Record that voter has voted
        voters[msg.sender].voted = true;

        // Store voter choice
        voters[msg.sender].vote = _candidateId;

        // Update candidate vote count
        candidates[_candidateId].voteCount++;

        // incrementing the total number of votes
        totalVotes++;

        // handling voting interaction
        emit votedEvent(_candidateId);
    }

    // counting total ballots for each candidate to get the ID of most voted candidate(winner)
    function winnerProposal() public view ownerOnly returns (uint256 _winnerID) {
        uint256 winingVoteCount = 0;
        for (uint256 i = 1; i < candidatesCount+1; i++) {
            if (candidates[i].voteCount > winingVoteCount) {
                winingVoteCount = candidates[i].voteCount;
                _winnerID = i;
            }
        }
    }

    // displaying the name of the winner
    function winnerName() public ownerOnly {
        electionWinner = candidates[winnerProposal()].name;
        emit winnerEvent();
    }
    
    // turning off the contract once the election has been finished
    function close() public ownerOnly {
        emit endElection();
        selfdestruct(msg.sender);
    }
}
//all rights reserved to Amr Ahmed Abd El Rahman
