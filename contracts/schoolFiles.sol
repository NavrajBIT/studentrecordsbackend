// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

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
    mapping(uint256 => uint256) public assignmentIdToExpiry;

    //Assignment Submissions
    uint256 public assignmentSolutionCount;
    mapping(uint256 => string) public assignmentSolutionIdTofile;
    mapping(uint256 => uint256) public assignmentSolutionIdToAssignmentId;
    mapping(uint256 => uint256) public assignmentSolutionIdToStudentId;

    // Marks card
    uint256 public marksCardCount;
    mapping(uint256 => string) public marksCardIdTofile;
    mapping(uint256 => uint256) public marksCardIdTostudentId;
    mapping(uint256 => uint256) public marksCardIdToclass;
    mapping(uint256 => uint256) public marksCardIdToExpiry;

    //Time table
    uint256 public timetableCount;
    mapping(uint256 => string) public timeTableIdTofile;
    mapping(uint256 => uint256) public timeTableIdToclass;
    mapping(uint256 => string) public timeTableIdToexam;
    mapping(uint256 => uint256) public timeTableIdToUploadTime;

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
        string memory _topic,
        uint256 _expiry
    ) public onlyOwner returns (uint256 assignmentId) {
        assignmentCount = assignmentCount + 1;
        assignmentIdTofile[assignmentCount] = _file;
        assignmentIdToclass[assignmentCount] = _class;
        assignmentIdTosubject[assignmentCount] = _subject;
        assignmentIdToTopic[assignmentCount] = _topic;
        assignmentIdToExpiry[assignmentCount] = _expiry;
        return assignmentCount;
    }

    function addAssignmentSolution(
        uint256 _assignmentId,
        string memory _file,
        uint256 _studentId
    ) public onlyOwner returns (uint256 _assignmentSolutionId) {
        assignmentSolutionCount = assignmentSolutionCount + 1;
        assignmentSolutionIdTofile[assignmentSolutionCount] = _file;
        assignmentSolutionIdToAssignmentId[
            assignmentSolutionCount
        ] = _assignmentId;
        assignmentSolutionIdToStudentId[assignmentSolutionCount] = _studentId;
        return assignmentSolutionCount;
    }

    function addMarksCard(
        uint256 _studentId,
        uint256 _class,
        string memory _file,
        uint256 _expiry
    ) public onlyOwner returns (uint256 marksCardId) {
        marksCardCount = marksCardCount + 1;
        marksCardIdTostudentId[marksCardCount] = _studentId;
        marksCardIdToclass[marksCardCount] = _class;
        marksCardIdTofile[marksCardCount] = _file;
        marksCardIdToExpiry[marksCardCount] = _expiry;
        return marksCardCount;
    }

    function addTimeTable(
        uint256 _class,
        string memory _exam,
        string memory _file,
        uint256 _uploadTime
    ) public onlyOwner {
        timetableCount = timetableCount + 1;
        timeTableIdToclass[timetableCount] = _class;
        timeTableIdToexam[timetableCount] = _exam;
        timeTableIdTofile[timetableCount] = _file;
        timeTableIdToUploadTime[timetableCount] = _uploadTime;
    }
}
