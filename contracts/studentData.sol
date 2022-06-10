// SPDX-License-Identifier: MIT

pragma solidity 0.8.14;

contract StudentData {
    uint256 public studentCount;
    uint256 public ownerCount;
    mapping(address => uint256) public ownerToOwnerId;
    uint256 public blockedOwnerCount;
    mapping(address => uint256) public blockedOwnerToOwnerId;

    struct PrimaryDetails {
        string name;
        uint256 rollNumber;
        uint256 dob;
        string gender;
    }

    struct SchoolDetails {
        uint256 class;
        string email;
        uint256 batch;
    }
    struct PersonalDetails {
        string currentAddress;
        string caste;
        string nationality;
    }
    struct ParentalDetails {
        string guardianName;
        string fatherName;
        string MotherName;
        string educationFather;
        string educationMother;
    }

    mapping(uint256 => PrimaryDetails) public studentIdToPrimaryDetails;
    mapping(uint256 => SchoolDetails) public studentIdToSchoolDetails;
    mapping(uint256 => PersonalDetails) public studentIdToPersonalDetails;
    mapping(uint256 => ParentalDetails) public studentIdToParentalDetails;
    mapping(uint256 => uint256) public rollNumberToStudentId;
    mapping(uint256 => uint256) public studentIdToRollNumber;

    constructor() {
        blockedOwnerCount = 0;
        ownerCount = 1;
        ownerToOwnerId[msg.sender] = ownerCount;
        studentCount = 0;
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

    function addStudent(
        string memory _name,
        uint256 _rollNumber,
        uint256 _dob,
        string memory _gender
    ) public onlyOwner returns (uint256 _studentId) {        
        studentCount = studentCount + 1;
        studentIdToPrimaryDetails[studentCount].name = _name;
        studentIdToPrimaryDetails[studentCount].rollNumber = _rollNumber;
        studentIdToPrimaryDetails[studentCount].dob = _dob;
        studentIdToPrimaryDetails[studentCount].gender = _gender;
        studentIdToRollNumber[studentCount] = _rollNumber;
        rollNumberToStudentId[_rollNumber] = studentCount;
        return studentCount;
    }

    function modifyPrimaryDetails(
        uint256 _studentId,
        string memory _name,
        uint256 _rollNumber,
        uint256 _dob,
        string memory _gender
    ) public onlyOwner {
        require(
            studentIdToRollNumber[_studentId] > 0,
            "Student does not exist"
        );
        studentIdToPrimaryDetails[_studentId].name = _name;
        studentIdToPrimaryDetails[_studentId].rollNumber = _rollNumber;
        studentIdToPrimaryDetails[_studentId].dob = _dob;
        studentIdToPrimaryDetails[_studentId].gender = _gender;
        studentIdToRollNumber[_studentId] = _rollNumber;
        rollNumberToStudentId[_rollNumber] = _studentId;
    }

    function schoolDetails(
        uint256 _studentId,
        uint256 _class,
        string memory _email,
        uint256 _batch
    ) public onlyOwner {
        require(
            studentIdToRollNumber[_studentId] > 0,
            "Student does not exist"
        );
        studentIdToSchoolDetails[_studentId].class = _class;
        studentIdToSchoolDetails[_studentId].email = _email;
        studentIdToSchoolDetails[_studentId].batch = _batch;
    }

    function personalDetails(
        uint256 _studentId,
        string memory _currentAddress,
        string memory _caste,
        string memory _nationality
    ) public onlyOwner {
        require(
            studentIdToRollNumber[_studentId] > 0,
            "Student does not exist"
        );
        studentIdToPersonalDetails[_studentId].currentAddress = _currentAddress;
        studentIdToPersonalDetails[_studentId].caste = _caste;
        studentIdToPersonalDetails[_studentId].nationality = _nationality;
    }

    function parentalDetails(
        uint256 _studentId,
        string memory _guardianName,
        string memory _fatherName,
        string memory _MotherName,
        string memory _educationFather,
        string memory _educationMother
    ) public onlyOwner {
        require(
            studentIdToRollNumber[_studentId] > 0,
            "Student does not exist"
        );
        studentIdToParentalDetails[_studentId].guardianName = _guardianName;
        studentIdToParentalDetails[_studentId].fatherName = _fatherName;
        studentIdToParentalDetails[_studentId].MotherName = _MotherName;
        studentIdToParentalDetails[_studentId]
            .educationFather = _educationFather;
        studentIdToParentalDetails[_studentId]
            .educationMother = _educationMother;
    }
}
