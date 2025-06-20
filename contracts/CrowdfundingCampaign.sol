// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract CrowdfundingCampaign {
    address public owner;
    string public campaignName;
    uint256 public goalAmount;
    uint256 public deadline;
    uint256 public totalRaised;
    bool public isWithdrawn;

    mapping(address => uint256) public contributions;

    event ContributionReceived(address contributor, uint256 amount);
    event FundsWithdrawn(address recipient, uint256 amount);
    event RefundIssued(address contributor, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not campaign owner");
        _;
    }

    modifier beforeDeadline() {
        require(block.timestamp < deadline, "Campaign has ended");
        _;
    }

    modifier afterDeadline() {
        require(block.timestamp >= deadline, "Campaign is still ongoing");
        _;
    }

    constructor(
        string memory _campaignName,
        uint256 _goalAmount,
        uint256 _durationInDays
    ) {
        owner = msg.sender;
        campaignName = _campaignName;
        goalAmount = _goalAmount;
        deadline = block.timestamp + (_durationInDays * 1 days);
        isWithdrawn = false;
    }

    function contribute() public payable beforeDeadline {
        require(msg.value > 0, "Contribution must be greater than 0");
        contributions[msg.sender] += msg.value;
        totalRaised += msg.value;
        emit ContributionReceived(msg.sender, msg.value);
    }

    function withdrawFunds() public onlyOwner afterDeadline {
        require(totalRaised >= goalAmount, "Goal not reached");
        require(!isWithdrawn, "Funds already withdrawn");
        isWithdrawn = true;
        payable(owner).transfer(totalRaised);
        emit FundsWithdrawn(owner, totalRaised);
    }

    function refund() public afterDeadline {
        require(totalRaised < goalAmount, "Goal was reached, no refunds");
        uint256 amount = contributions[msg.sender];
        require(amount > 0, "No contributions to refund");

        contributions[msg.sender] = 0;
        payable(msg.sender).transfer(amount);
        emit RefundIssued(msg.sender, amount);
    }
}
