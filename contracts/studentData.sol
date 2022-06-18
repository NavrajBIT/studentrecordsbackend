// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

contract StudentData {
    uint256 public studentCount;
    uint256 public ownerCount;
    mapping(address => uint256) public ownerToOwnerId;
    uint256 public blockedOwnerCount;
    mapping(address => uint256) public blockedOwnerToOwnerId;

    struct PrimaryDetails {
        string studentName;
        uint256 dob;
        uint256 rollNumber;
        uint256 grade;
        string email;
    }
    struct PersonalDetails {
        string religion;
        string caste;
        string nationality;
        uint256 aadharNumber;
        string gender;
    }
    struct PaternalDetails {
        string fatherName;
        string currentAddress;
        string officeAddress;
        string fatherOccupation;
        string fatherEducation;
    }
    struct MaternalDetails {
        string motherName;
        string motherOccupation;
        string motherEducation;
    }
    struct GuardianDetails {
        string guardianName;
        string guardianAddress;
    }
    struct FamilyDetails {
        uint256 familyIncome;
        uint256 primaryContact;
        uint256 secondaryContact;
    }
    struct Files {
        string uploadAadharFront;
        string uploadAadharBack;
        string uploadIncomeCertificate;
        string uploadBirthCertificate;
        string uploadCasteCertificate;
    }

    struct NonAcademic {
        string sportsInvolved;
        string sportsAchievements;
        string extraCurricullum;
        string extraCurricullumAchievements;
        string personalityDevelopment;
        string personalityDevelopmentAchievements;
    }

    mapping(uint256 => PrimaryDetails) public studentIdToPrimaryDetails;
    mapping(uint256 => PersonalDetails) public studentIdToPersonalDetails;
    mapping(uint256 => PaternalDetails) public studentIdToPaternalDetails;
    mapping(uint256 => MaternalDetails) public studentIdToMaternalDetails;
    mapping(uint256 => GuardianDetails) public studentIdToGuardianDetails;
    mapping(uint256 => FamilyDetails) public studentIdToFamilyDetails;
    mapping(uint256 => Files) public studentIdToFiles;
    mapping(uint256 => NonAcademic) public studentIdToNonAcademic;

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
        string memory _studentName,
        uint256 _dob,
        uint256 _rollNumber,
        uint256 _grade,
        string memory _email
    ) public onlyOwner returns (uint256 _studentId) {
        require(
            rollNumberToStudentId[_rollNumber] == 0,
            "This roll number already exists"
        );
        studentCount = studentCount + 1;
        studentIdToPrimaryDetails[studentCount].studentName = _studentName;
        studentIdToPrimaryDetails[studentCount].dob = _dob;
        studentIdToPrimaryDetails[studentCount].rollNumber = _rollNumber;
        studentIdToPrimaryDetails[studentCount].grade = _grade;
        studentIdToPrimaryDetails[studentCount].email = _email;
        studentIdToRollNumber[studentCount] = _rollNumber;
        rollNumberToStudentId[_rollNumber] = studentCount;
        return studentCount;
    }

    function modifyPrimaryDetails(
        uint256 _studentId,
        string memory _studentName,
        uint256 _dob,
        uint256 _grade,
        string memory _email
    ) public onlyOwner {
        require(
            studentIdToRollNumber[_studentId] > 0,
            "Student does not exist"
        );
        studentIdToPrimaryDetails[_studentId].studentName = _studentName;
        studentIdToPrimaryDetails[_studentId].dob = _dob;
        studentIdToPrimaryDetails[_studentId].grade = _grade;
        studentIdToPrimaryDetails[_studentId].email = _email;
    }

    function addPersonalDetails(
        uint256 _studentId,
        string memory _religion,
        string memory _caste,
        string memory _nationality,
        uint256 _aadharNumber,
        string memory _gender
    ) public onlyOwner {
        require(
            studentIdToRollNumber[_studentId] > 0,
            "Student does not exist"
        );
        studentIdToPersonalDetails[_studentId].religion = _religion;
        studentIdToPersonalDetails[_studentId].caste = _caste;
        studentIdToPersonalDetails[_studentId].nationality = _nationality;
        studentIdToPersonalDetails[_studentId].aadharNumber = _aadharNumber;
        studentIdToPersonalDetails[_studentId].gender = _gender;
    }

    function addPaternalDetails(
        uint256 _studentId,
        string memory _fatherName,
        string memory _currentAddress,
        string memory _officeAddress,
        string memory _fatherOccupation,
        string memory _fatherEducation
    ) public onlyOwner {
        require(
            studentIdToRollNumber[_studentId] > 0,
            "Student does not exist"
        );
        studentIdToPaternalDetails[_studentId].fatherName = _fatherName;
        studentIdToPaternalDetails[_studentId].currentAddress = _currentAddress;
        studentIdToPaternalDetails[_studentId].officeAddress = _officeAddress;
        studentIdToPaternalDetails[_studentId]
            .fatherOccupation = _fatherOccupation;
        studentIdToPaternalDetails[_studentId]
            .fatherEducation = _fatherEducation;
    }

    function addMaternalDetails(
        uint256 _studentId,
        string memory _motherName,
        string memory _motherOccupation,
        string memory _motherEducation
    ) public onlyOwner {
        require(
            studentIdToRollNumber[_studentId] > 0,
            "Student does not exist"
        );
        studentIdToMaternalDetails[_studentId].motherName = _motherName;
        studentIdToMaternalDetails[_studentId]
            .motherOccupation = _motherOccupation;
        studentIdToMaternalDetails[_studentId]
            .motherEducation = _motherEducation;
    }

    function addGuardianDetails(
        uint256 _studentId,
        string memory _guardianName,
        string memory _guardianAddress
    ) public onlyOwner {
        require(
            studentIdToRollNumber[_studentId] > 0,
            "Student does not exist"
        );
        studentIdToGuardianDetails[_studentId].guardianName = _guardianName;
        studentIdToGuardianDetails[_studentId]
            .guardianAddress = _guardianAddress;
    }

    function addFamilyDetails(
        uint256 _studentId,
        uint256 _familyIncome,
        uint256 _primaryContact,
        uint256 _secondaryContact
    ) public onlyOwner {
        require(
            studentIdToRollNumber[_studentId] > 0,
            "Student does not exist"
        );
        studentIdToFamilyDetails[_studentId].familyIncome = _familyIncome;
        studentIdToFamilyDetails[_studentId].primaryContact = _primaryContact;
        studentIdToFamilyDetails[_studentId]
            .secondaryContact = _secondaryContact;
    }

    function addFiles(
        uint256 _studentId,
        string memory _uploadAadharFront,
        string memory _uploadAadharBack,
        string memory _uploadIncomeCertificate,
        string memory _uploadBirthCertificate,
        string memory _uploadCasteCertificate
    ) public onlyOwner {
        require(
            studentIdToRollNumber[_studentId] > 0,
            "Student does not exist"
        );
        studentIdToFiles[_studentId].uploadAadharFront = _uploadAadharFront;
        studentIdToFiles[_studentId].uploadAadharBack = _uploadAadharBack;
        studentIdToFiles[_studentId]
            .uploadIncomeCertificate = _uploadIncomeCertificate;
        studentIdToFiles[_studentId]
            .uploadBirthCertificate = _uploadBirthCertificate;
        studentIdToFiles[_studentId]
            .uploadCasteCertificate = _uploadCasteCertificate;
    }

    function addNonAcademic(
        uint256 _studentId,
        string memory _sportsInvolved,
        string memory _sportsAchievements,
        string memory _extraCurricullum,
        string memory _extraCurricullumAchievements,
        string memory _personalityDevelopment,
        string memory _personalityDevelopmentAchievements
    ) public onlyOwner {
        require(
            studentIdToRollNumber[_studentId] > 0,
            "Student does not exist"
        );
        studentIdToNonAcademic[_studentId].sportsInvolved = _sportsInvolved;
        studentIdToNonAcademic[_studentId]
            .sportsAchievements = _sportsAchievements;
        studentIdToNonAcademic[_studentId].extraCurricullum = _extraCurricullum;
        studentIdToNonAcademic[_studentId]
            .extraCurricullumAchievements = _extraCurricullumAchievements;
        studentIdToNonAcademic[_studentId]
            .personalityDevelopment = _personalityDevelopment;
        studentIdToNonAcademic[_studentId]
            .personalityDevelopmentAchievements = _personalityDevelopmentAchievements;
    }
}
