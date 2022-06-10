// SPDX-License-Identifier: MIT

pragma solidity 0.8.14;

contract Login {
    uint256 public ownerCount;
    mapping(address => uint256) public ownerToOwnerId;
    uint256 public blockedOwnerCount;
    mapping(address => uint256) public blockedOwnerToOwnerId;

    uint256 public adminCount;
    mapping(uint256 => string) adminIdToName;
    mapping(uint256 => string) adminIdToPassword;

    uint256 public studentCount;
    mapping(uint256 => string) studentIdToName;
    mapping(uint256 => string) studentIdToPassword;
    mapping(uint256 => uint256) studentIdTostudentId;

    constructor() {
        adminCount = 0;
        studentCount = 0;

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

    function addAdmin(string memory _name, string memory _password)
        public
        onlyOwner
    {
        adminCount = adminCount + 1;
        adminIdToName[adminCount] = _name;
        adminIdToPassword[adminCount] = _password;
    }

    function addStudent(
        string memory _name,
        string memory _password,
        uint256 _studentId
    ) public onlyOwner {
        studentCount = studentCount + 1;
        studentIdToName[studentCount] = _name;
        studentIdToPassword[studentCount] = _password;
        studentIdTostudentId[studentCount] = _studentId;
    }

    function loginCheck(string memory _name, string memory _password)
        public
        view
        onlyOwner
        returns (string memory _loginType, uint256 _id)
    {
        for (uint256 i = 1; i <= adminCount; i++) {
            if (
                keccak256(abi.encodePacked(_name)) ==
                keccak256(abi.encodePacked(adminIdToName[i])) &&
                keccak256(abi.encodePacked(_password)) ==
                keccak256(abi.encodePacked(adminIdToPassword[i]))
            ) {
                return ("Admin", i);
            }
        }
        for (uint256 i = 1; i <= studentCount; i++) {
            if (
                keccak256(abi.encodePacked(_name)) ==
                keccak256(abi.encodePacked(studentIdToName[i])) &&
                keccak256(abi.encodePacked(_password)) ==
                keccak256(abi.encodePacked(studentIdToPassword[i]))
            ) {
                return ("Student", studentIdTostudentId[i]);
            }
        }
        return ("Unauthorized", 0);
    }
}
