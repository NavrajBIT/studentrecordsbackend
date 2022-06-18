// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

contract Attendance {
    // attendanceValue  = 1 => Present, 2 => Absent,  3 => on leave, 4 => Holiday/WeeklyOff

    uint256 public attendanceCount;

    struct AttendanceMark {
        uint256 studentId;
        uint256 attendanceValue;
        uint256 date;
    }

    mapping(uint256 => AttendanceMark) public dateToAttendanceMark;

    uint256 public ownerCount;
    mapping(address => uint256) public ownerToOwnerId;
    uint256 public blockedOwnerCount;
    mapping(address => uint256) public blockedOwnerToOwnerId;

    constructor() {
        blockedOwnerCount = 0;
        ownerCount = 1;
        ownerToOwnerId[msg.sender] = ownerCount;
        attendanceCount = 0;
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

    function markAttendance(
        uint256 _studentId,
        uint256 _attendanceValue,
        uint256 _date
    ) public onlyOwner {
        dateToAttendanceMark[_date].studentId = _studentId;
        dateToAttendanceMark[_date].attendanceValue = _attendanceValue;
        dateToAttendanceMark[_date].date = _date;
    }
}
