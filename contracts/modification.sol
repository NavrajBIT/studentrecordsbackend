// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

contract Modification {
    uint256 public requestCount;
    uint256 public pendingRequestCount;
    uint256 public rejectedRequestCount;
    uint256 public approvedRequestCount;
    uint256 public closedRequestCount;

    mapping(uint256 => uint256) public requestIdToStudentId;
    mapping(uint256 => string) public requestIdTotitle;
    mapping(uint256 => string) public requestIdToDescription;
    mapping(uint256 => string) public requestIdToFile;
    mapping(uint256 => string) public requestIdToStatus;

    uint256 public ownerCount;
    mapping(address => uint256) public ownerToOwnerId;
    uint256 public blockedOwnerCount;
    mapping(address => uint256) public blockedOwnerToOwnerId;

    constructor() {
        blockedOwnerCount = 0;
        ownerCount = 1;
        ownerToOwnerId[msg.sender] = ownerCount;
        requestCount = 0;
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

    function raiseRequest(
        uint256 _studentId,
        string memory _title,
        string memory _file,
        string memory _description
    ) public onlyOwner {
        requestCount = requestCount + 1;
        requestIdToStudentId[requestCount] = _studentId;
        requestIdTotitle[requestCount] = _title;
        requestIdToDescription[requestCount] = _description;
        requestIdToStatus[requestCount] = "Pending";
        requestIdToFile[requestCount] = _file;
        pendingRequestCount = pendingRequestCount + 1;
    }

    function closeRequest(uint256 _requestId) public onlyOwner {
        requestIdToStatus[_requestId] = "Closed";
        approvedRequestCount = approvedRequestCount - 1;
        closedRequestCount = closedRequestCount + 1;
    }

    function rejectRequest(uint256 _requestId) public onlyOwner {
        requestIdToStatus[_requestId] = "Rejected";
        pendingRequestCount = pendingRequestCount - 1;
        rejectedRequestCount = rejectedRequestCount + 1;
    }

    function approveRequest(uint256 _requestId) public onlyOwner {
        requestIdToStatus[_requestId] = "Approved";
        pendingRequestCount = pendingRequestCount - 1;
        approvedRequestCount = approvedRequestCount + 1;
    }
}
