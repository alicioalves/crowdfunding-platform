pragma solidity ^0.8.17;

// Importing OpenZeppeling's SafeMath Implementation


contract Crowdfunding {
  // List of existing projects
  Project[] private projects;

  // Event that will be emitted whenever a new project is started
  event ProjectStarted(
    address contractAddress,
    address projectStarted,
    string projectTitle,
    string ProjectDesc,
    uint256 deadline,
    uint256 goalAmount
  );

  /** @dev Function to start a new project.
   * @param title Title of the project to be created
   * @param description Brief description about the project
   * @param durationInDays Project deadline in days
   * @param amountToRaise Project goal in wei
   */
  function startProject(
    string calldata title,
    string calldata description,
    uint durationInDays,
    uint amountToRaise
  ) external {
   uint durationInSeconds = durationInDays * 1 days;

    // Check that the result of division (inverse operation to multiplication) is the original number.
    // If it's not, throw an exception, because the multiplication overflowed.
    require(durationInSeconds / durationInDays == 1 days, 'Multiplication overflow');

    uint raiseUntil = block.timestamp + durationInSeconds;

    // Check that the result of subtraction (inverse operation to addition) is the original number.
    // If it's not, throw an exception, because the addition overflowed.
    require(raiseUntil - block.timestamp == durationInSeconds, 'Addition overflow');

    Project newProject = new Project(payable(msg.sender), title, description, raiseUntil, amountToRaise);
    projects.push(newProject);
    emit ProjectStarted(
      address(newProject),
      msg.sender,
      title,
      description,
      raiseUntil,
      amountToRaise
    );
  }

  /** @dev Function to get all projects' contract address
   * @return projects A list of all projects' contract addresses
   */
  function returnAllProjects() external view returns(Project[] memory){
    return projects;
  }
}

contract Project {

  // Data structures
  enum State {
    Fundraising,
    Expired,
    Successful
  }

  // State variables
  address payable public creator;
  uint public amountGoal; // required to reach at least this much, ese everyone gets refund
  uint public completeAt;
  uint256 public currentBalance;
  uint public raiseBy;
  string public title;
  string public description;
  State public state = State.Fundraising; // initialize on create
  mapping (address => uint) public contributions;

  // Event that will be emitted whenever funding will be received
  event FundingReceived(address contributor, uint amount, uint currentTotal);
  // Event that will be emitted whenever the project started has received the funds
  event CreatorPaid(address recipient);

  // Modifier to check current state
  modifier inState(State _state) {
    require(state == _state);
    _;
  }

  // Modifier to check if the function caller is the project creator
  modifier isCreator(){
    require(msg.sender == creator);
    _;
  }

  constructor
  (
    address payable projectStarter,
    string memory projectTitle,
    string memory projectDesc,
    uint fundRaisingDeadline,
    uint goalAmount
  ) public {
    creator = projectStarter;
    title = projectTitle;
    description = projectDesc;
    amountGoal = goalAmount;
    raiseBy = fundRaisingDeadline;
    currentBalance = 0;
  }

  /** @dev Function to fund a certain project. */
  function contribute() external inState(State.Fundraising) payable {
    require(msg.sender != creator);
    contributions[msg.sender] = contributions[msg.sender] + (msg.value);
    currentBalance = currentBalance + (msg.value);
    emit FundingReceived(msg.sender, msg.value, currentBalance);
    checkIfFundingCompleteOrExpired();
  }

  /** @dev Function to change the project state depending on conditions. */
  function checkIfFundingCompleteOrExpired() public {
    if (currentBalance >= amountGoal) {
      state = State.Successful;
      payOut();
    } else if (block.timestamp > raiseBy) {
      state = State.Expired;
    }
    completeAt = block.timestamp;
  }

  /** @dev Function to give the received funds to project starter. */
  function payOut() internal inState(State.Successful) returns (bool) {
    uint256 totalRaised = currentBalance;
    currentBalance = 0;

    if(creator.send(totalRaised)) {
      emit CreatorPaid(creator);
      return true;
    } else {
      currentBalance = totalRaised;
      state = State.Successful;
    }

    return false;
  }

  /** @dev Function to retrieve donated amount when a project expires. */
  function getRefund() public inState(State.Expired) returns (bool) {
    require(contributions[msg.sender] > 0);

    uint amountToRefund = contributions[msg.sender];
    contributions[msg.sender] = 0;

    if (!payable(msg.sender).send(amountToRefund)) {
      contributions[msg.sender] = amountToRefund;
      return false;
    } else {
      currentBalance = currentBalance - amountToRefund;
    }

    return true;
  }

  /** @dev Function to get specific information about the project. */
  function getDetails() public view returns
  (
    address payable projectStarter,
    string memory projectTitle,
    string memory projectDesc,
    uint256 deadline,
    State currentState,
    uint256 currentAmount,
    uint256 goalAmount
  ) {
    projectStarter = creator;
    projectTitle = title;
    projectDesc = description;
    deadline = raiseBy;
    currentState = state;
    currentAmount = currentBalance;
    goalAmount = amountGoal;
  }
}
