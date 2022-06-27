// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

contract Performance {
    uint256 public ownerCount;
    mapping(address => uint256) public ownerToOwnerId;
    uint256 public blockedOwnerCount;
    mapping(address => uint256) public blockedOwnerToOwnerId;

    mapping(uint256 => uint256) public gradeToBatchCount;
    mapping(uint256 => mapping(uint256 => uint256))
        public gradeToBatchIdToBatch;
    mapping(uint256 => mapping(uint256 => uint256))
        public gradeToBatchToBatchId;

    struct PerformanceIndicator {
        uint256 totalStudents;
        uint256 passedStudents;
        uint256 failedStudents;
    }

    mapping(uint256 => mapping(uint256 => PerformanceIndicator))
        public batchToGradeToPerformanceIndicator;

    constructor() {
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

    function addPerformanceIndicator(
        uint256 _grade,
        uint256 _batch,
        uint256 _totalStudents,
        uint256 _passedStudents,
        uint256 _failedStudents
    ) public onlyOwner {
        if (gradeToBatchToBatchId[_grade][_batch] == 0) {
            gradeToBatchCount[_grade] = gradeToBatchCount[_grade] + 1;
            uint256 batchId = gradeToBatchCount[_grade];
            gradeToBatchIdToBatch[_grade][batchId] = _batch;
            gradeToBatchToBatchId[_grade][_batch] = batchId;
        }
        batchToGradeToPerformanceIndicator[_batch][_grade]
            .totalStudents = _totalStudents;
        batchToGradeToPerformanceIndicator[_batch][_grade]
            .passedStudents = _passedStudents;
        batchToGradeToPerformanceIndicator[_batch][_grade]
            .failedStudents = _failedStudents;
    }

    function getBatchFromId(uint256 _grade, uint256 _batchId)
        public
        view
        onlyOwner
        returns (uint256 batchId)
    {
        return gradeToBatchIdToBatch[_grade][_batchId];
    }

    function getPerformanceIndicator(uint256 _batch, uint256 _grade)
        public
        view
        onlyOwner
        returns (
            uint256 totalStudents,
            uint256 passedStudents,
            uint256 failedStudents
        )
    {
        return (
            batchToGradeToPerformanceIndicator[_batch][_grade].totalStudents,
            batchToGradeToPerformanceIndicator[_batch][_grade].passedStudents,
            batchToGradeToPerformanceIndicator[_batch][_grade].failedStudents
        );
    }
}
