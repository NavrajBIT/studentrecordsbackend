// SPDX-License-Identifier: MIT

pragma solidity 0.8.14;

import "./studentData.sol";

contract SchoolFiles {
    uint256 public ownerCount;
    mapping(address => uint256) public ownerToOwnerId;
    uint256 public blockedOwnerCount;
    mapping(address => uint256) public blockedOwnerToOwnerId;

    //Assignments
    uint256 public assignmentCount;
    mapping(uint256 => string) public assignmentIdTofile;
    mapping(uint256 => uint256) public assignmentIdToclass;
    mapping(uint256 => string) public assignmentIdTosubject;
    mapping(uint256 => string) public assignmentIdToTopic;

    // Marks card
    uint256 public marksCardCount;
    mapping(uint256 => string) public marksCardIdTofile;
    mapping(uint256 => uint256) public marksCardIdTostudentId;
    mapping(uint256 => uint256) public marksCardIdToclass;

    //Time table
    uint256 public timetableCount;
    mapping(uint256 => string) public timeTableIdTofile;
    mapping(uint256 => uint256) public timeTableIdToclass;
    mapping(uint256 => string) public timeTableIdToexam;

    constructor() {
        assignmentCount = 0;
        marksCardCount = 0;
        timetableCount = 0;

        blockedOwnerCount = 0;
        ownerCount = 1;
        ownerToOwnerId[msg.sender] = ownerCount;
    }

    modifier onlyOwner() {
        require(
            ownerToOwnerId[msg.sender] > 0,
            "Only owner can call this function."
        );
        require(
            blockedOwnerToOwnerId[msg.sender] == 0,
            "You have been blocked."
        );
        _;
    }

    function setOwner(address _newOwner) public onlyOwner {
        require(ownerToOwnerId[_newOwner] == 0, "Owner already added.");
        ownerCount = ownerCount + 1;
        ownerToOwnerId[_newOwner] = ownerCount;
    }

    function blockOwner(address _owner) external onlyOwner {
        require(msg.sender != _owner, "You cannot block yourself");
        blockedOwnerCount = blockedOwnerCount + 1;
        blockedOwnerToOwnerId[_owner] = blockedOwnerCount;
    }

    function addAssignment(
        uint256 _class,
        string memory _subject,
        string memory _file,
        string memory _topic
    ) public onlyOwner returns (uint256 assignmentId) {
        assignmentCount = assignmentCount + 1;
        assignmentIdTofile[assignmentCount] = _file;
        assignmentIdToclass[assignmentCount] = _class;
        assignmentIdTosubject[assignmentCount] = _subject;
        assignmentIdToTopic[assignmentCount] = _topic;
        return assignmentCount;
    }

    function addMarksCard(
        uint256 _studentId,
        uint256 _class,
        string memory _file
    ) public onlyOwner {
        marksCardCount = marksCardCount + 1;
        marksCardIdTostudentId[marksCardCount] = _studentId;
        marksCardIdToclass[marksCardCount] = _class;
        marksCardIdTofile[marksCardCount] = _file;
    }

    function addTimeTable(
        uint256 _class,
        string memory _exam,
        string memory _file
    ) public onlyOwner {
        timetableCount = timetableCount + 1;
        timeTableIdToclass[timetableCount] = _class;
        timeTableIdToexam[timetableCount] = _exam;
        timeTableIdTofile[timetableCount] = _file;
    }
}
