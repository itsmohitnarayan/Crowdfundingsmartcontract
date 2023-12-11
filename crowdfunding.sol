// SPDX-License-Identifier: GPL-3.0

// Solidity version specification
pragma solidity >=0.6.0 <0.9.0;

// Crowdfunding contract
contract Crowdfunding {
    // Mapping to store contributors and their contributed amounts
    mapping (address => uint) public contributors;
    
    // Address of the admin
    address public admin;
    
    // Number of contributors
    uint public noOfContributors;
    
    // Minimum contribution required from each contributor
    uint public minimumContribution;
    
    // Crowdfunding deadline
    uint public deadline;
    
    // Funding goal
    uint public goal;
    
    // Total amount raised
    uint public raisedAmount;
    
    // Struct to represent a funding request
    struct Request {
        string description;               // Description of the funding request
        address payable recipient;        // Recipient address for the funds
        uint value;                       // Amount of funds requested
        bool completed;                   // Flag to indicate if the request is completed
        uint noOfVoters;                  // Number of voters for the request
        mapping(address => bool) voters;  // Mapping to track voters
    }

    // Mapping to store funding requests
    mapping(uint => Request) public requests;

    // Number of funding requests
    uint public numRequests;

    // Constructor to initialize the contract with goal, deadline, minimum contribution, and admin
    constructor(uint _goal, uint _deadline) {
        goal = _goal;
        deadline = block.timestamp + _deadline;
        minimumContribution = 100 wei;
        admin = msg.sender;
    }

    // Event emitted when a contribution is made
    event ContributeEvent(address _sender, uint _value);
    
    // Event emitted when a funding request is created
    event CreateRequestEvent(string _description, address _recipient, uint _value);
    
    // Event emitted when a payment is made for a funding request
    event MakePaymentEvent(address _recipient, uint _value);

    // Function to allow contributors to contribute funds
    function contribute() public payable {
        require(block.timestamp < deadline, "Deadline has passed!");
        require(msg.value >= minimumContribution, "Minimum Contribution not met!");

        if (contributors[msg.sender] == 0) {
            noOfContributors++;
        }

        contributors[msg.sender] += msg.value;
        raisedAmount += msg.value;

        emit ContributeEvent(msg.sender, msg.value);
    }

    // Fallback function to allow receiving ether
    receive() payable external {
        contribute();
    }

    // Function to get the balance of the contract
    function getBalance() public view returns(uint) {
        return address(this).balance;
    }

    // Function to allow contributors to request a refund if the goal is not met by the deadline
    function getRefund() public {
        require(block.timestamp > deadline && raisedAmount < goal);
        require(contributors[msg.sender] > 0);

        address payable recipient = payable(msg.sender);
        uint value = contributors[msg.sender];
        recipient.transfer(value);

        contributors[msg.sender] = 0;
    }

    // Modifier to restrict access to only the admin
    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can call this function!");
        _;
    }

    // Function for the admin to create a funding request
    function createRequest(string memory _description, address payable _recipient, uint _value) public onlyAdmin {
        Request storage newRequest = requests[numRequests];
        numRequests++;

        newRequest.description = _description;
        newRequest.recipient = _recipient;
        newRequest.value = _value;
        newRequest.completed = false;
        newRequest.noOfVoters = 0;

        emit CreateRequestEvent(_description, _recipient, _value);
    }

    // Function for contributors to vote on a funding request
    function voteRequest(uint _requestNo) public {
        require(contributors[msg.sender] > 0, "You must be a contributor to vote!");
        Request storage thisRequest = requests[_requestNo];

        require(thisRequest.voters[msg.sender] == false, "You have already voted!");
        thisRequest.voters[msg.sender] = true;
        thisRequest.noOfVoters++; 
    }

    // Function for the admin to make a payment for a completed funding request
    function makePayment(uint _requestNo) public onlyAdmin {
        require(raisedAmount >= goal);
        Request storage thisRequest = requests[_requestNo];
        require(thisRequest.completed == false, "This request has been completed!");
        require(thisRequest.noOfVoters > noOfContributors / 2);

        thisRequest.recipient.transfer(thisRequest.value);
        thisRequest.completed = true;

        emit MakePaymentEvent(thisRequest.recipient, thisRequest.value);
    }
}
