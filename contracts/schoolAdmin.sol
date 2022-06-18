// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "./studentData.sol";
import "./schoolFiles.sol";
import "./login.sol";
import "./attendance.sol";

contract SchoolAdmin {
    StudentData studentData;
    SchoolFiles schoolFiles;
    Login login;
    Attendance attendance;
    address public admin;
    uint256 public maleStudents;
    uint256 public femaleStudents;

    event studentAdded(
        uint256 indexed _studentId,
        uint256 indexed _rollNumber,
        uint256 indexed _class
    );
    event studentFound(uint256 indexed _studentId, uint256 indexed _rollNumber);
    event assignmentAdded(
        uint256 indexed _assignmentId,
        uint256 indexed _class,
        uint256 indexed _expiry
    );
    event assignmentSolutionAdded(
        uint256 indexed _assignmentId,
        uint256 indexed _solutionId,
        uint256 indexed _studentId
    );
    event marksCardAdded(
        uint256 indexed _marksCardId,
        uint256 indexed _studentId,
        uint256 indexed _expiry
    );

    event attendanceMarked(
        uint256 indexed _studentId,
        uint256 indexed _attendanceValue,
        uint256 indexed _date
    );

    constructor(
        address _studentData,
        address _schoolFiles,
        address _login,
        address _attendance
    ) {
        studentData = StudentData(_studentData);
        schoolFiles = SchoolFiles(_schoolFiles);
        login = Login(_login);
        attendance = Attendance(_attendance);
        admin = msg.sender;
    }

    modifier isAdmin() {
        require(msg.sender == admin, "You are not the admin");
        _;
    }

    function getStudentCount()
        public
        view
        isAdmin
        returns (uint256 studentCount)
    {
        uint256 _studentCount = studentData.studentCount();
        return _studentCount;
    }

    function rollNumberToStudentId(uint256 _rollNumber)
        public
        view
        isAdmin
        returns (uint256 studentId)
    {
        uint256 _studentId = studentData.rollNumberToStudentId(_rollNumber);
        return _studentId;
    }

    function getPrimaryDetails(uint256 _studentId)
        public
        view
        isAdmin
        returns (
            string memory _studentName,
            uint256 _dob,
            uint256 _rollNumber,
            uint256 _grade,
            string memory _email
        )
    {
        return studentData.studentIdToPrimaryDetails(_studentId);
    }

    function getPersonalDetails(uint256 _studentId)
        public
        view
        isAdmin
        returns (
            string memory _religion,
            string memory _caste,
            string memory _nationality,
            uint256 _aadharNumber,
            string memory _gender
        )
    {
        return studentData.studentIdToPersonalDetails(_studentId);
    }

    function getPaternalDetails(uint256 _studentId)
        public
        view
        isAdmin
        returns (
            string memory _fatherName,
            string memory _currentAddress,
            string memory _officeAddress,
            string memory _fatherOccupation,
            string memory _fatherEducation
        )
    {
        return studentData.studentIdToPaternalDetails(_studentId);
    }

    function getMaternalDetails(uint256 _studentId)
        public
        view
        isAdmin
        returns (
            string memory _motherName,
            string memory _motherOccupation,
            string memory _motherEducation
        )
    {
        return studentData.studentIdToMaternalDetails(_studentId);
    }

    function getGuardianDetails(uint256 _studentId)
        public
        view
        isAdmin
        returns (string memory _guardianName, string memory _guardianAddress)
    {
        return studentData.studentIdToGuardianDetails(_studentId);
    }

    function getFamilyDetails(uint256 _studentId)
        public
        view
        isAdmin
        returns (
            uint256 _familyIncome,
            uint256 _primaryContact,
            uint256 _secondaryContact
        )
    {
        return studentData.studentIdToFamilyDetails(_studentId);
    }

    function getFiles(uint256 _studentId)
        public
        view
        isAdmin
        returns (
            string memory _uploadAadharFront,
            string memory _uploadAadharBack,
            string memory _uploadIncomeCertificate,
            string memory _uploadBirthCertificate,
            string memory _uploadCasteCertificate
        )
    {
        return studentData.studentIdToFiles(_studentId);
    }

    function getNonAcademic(uint256 _studentId)
        public
        view
        isAdmin
        returns (
            string memory _sportsInvolved,
            string memory _sportsAchievements,
            string memory _extraCurricullum,
            string memory _extraCurricullumAchievements,
            string memory _personalityDevelopment,
            string memory _personalityDevelopmentAchievements
        )
    {
        return studentData.studentIdToNonAcademic(_studentId);
    }

    function addStudent(
        string memory _studentName,
        uint256 _dob,
        uint256 _rollNumber,
        uint256 _grade,
        string memory _email
    ) public isAdmin {
        uint256 _studentId = studentData.addStudent(
            _studentName,
            _dob,
            _rollNumber,
            _grade,
            _email
        );
        emit studentAdded(_studentId, _rollNumber, _grade);
    }

    function modifyPrimaryDetails(
        uint256 _studentId,
        string memory _studentName,
        uint256 _dob,
        uint256 _grade,
        string memory _email
    ) public isAdmin {
        studentData.modifyPrimaryDetails(
            _studentId,
            _studentName,
            _dob,
            _grade,
            _email
        );
    }

    function addPersonalDetails(
        uint256 _studentId,
        string memory _religion,
        string memory _caste,
        string memory _nationality,
        uint256 _aadharNumber,
        string memory _gender
    ) public isAdmin {
        studentData.addPersonalDetails(
            _studentId,
            _religion,
            _caste,
            _nationality,
            _aadharNumber,
            _gender
        );
    }

    function addPaternalDetails(
        uint256 _studentId,
        string memory _fatherName,
        string memory _currentAddress,
        string memory _officeAddress,
        string memory _fatherOccupation,
        string memory _fatherEducation
    ) public isAdmin {
        studentData.addPaternalDetails(
            _studentId,
            _fatherName,
            _currentAddress,
            _officeAddress,
            _fatherOccupation,
            _fatherEducation
        );
    }

    function addMaternalDetails(
        uint256 _studentId,
        string memory _motherName,
        string memory _motherOccupation,
        string memory _motherEducation
    ) public isAdmin {
        studentData.addMaternalDetails(
            _studentId,
            _motherName,
            _motherOccupation,
            _motherEducation
        );
    }

    function addGuardianDetails(
        uint256 _studentId,
        string memory _guardianName,
        string memory _guardianAddress
    ) public isAdmin {
        studentData.addGuardianDetails(
            _studentId,
            _guardianName,
            _guardianAddress
        );
    }

    function addFamilyDetails(
        uint256 _studentId,
        uint256 _familyIncome,
        uint256 _primaryContact,
        uint256 _secondaryContact
    ) public isAdmin {
        studentData.addFamilyDetails(
            _studentId,
            _familyIncome,
            _primaryContact,
            _secondaryContact
        );
    }

    function addFiles(
        uint256 _studentId,
        string memory _uploadAadharFront,
        string memory _uploadAadharBack,
        string memory _uploadIncomeCertificate,
        string memory _uploadBirthCertificate,
        string memory _uploadCasteCertificate
    ) public isAdmin {
        studentData.addFiles(
            _studentId,
            _uploadAadharFront,
            _uploadAadharBack,
            _uploadIncomeCertificate,
            _uploadBirthCertificate,
            _uploadCasteCertificate
        );
    }

    function addNonAcademic(
        uint256 _studentId,
        string memory _sportsInvolved,
        string memory _sportsAchievements,
        string memory _extraCurricullum,
        string memory _extraCurricullumAchievements,
        string memory _personalityDevelopment,
        string memory _personalityDevelopmentAchievements
    ) public isAdmin {
        studentData.addNonAcademic(
            _studentId,
            _sportsInvolved,
            _sportsAchievements,
            _extraCurricullum,
            _extraCurricullumAchievements,
            _personalityDevelopment,
            _personalityDevelopmentAchievements
        );
    }

    function searchStudent(string memory _name, uint256 _class) public isAdmin {
        uint256 studentCount = getStudentCount();
        for (uint256 studentId = 1; studentId <= studentCount; studentId++) {
            (
                string memory studentName,
                ,
                uint256 studentRollNumber,
                uint256 studentClass,

            ) = studentData.studentIdToPrimaryDetails(studentId);
            if (
                keccak256(abi.encodePacked(studentName)) ==
                keccak256(abi.encodePacked(_name))
            ) {
                if (studentClass == _class) {
                    emit studentFound(studentId, studentRollNumber);
                }
            }
        }
    }

    function addAssignmentSolution(
        uint256 _assignmentId,
        string memory _file,
        uint256 _studentId
    ) public {
        uint256 assignmentSolutionId = schoolFiles.addAssignmentSolution(
            _assignmentId,
            _file,
            _studentId
        );
        emit assignmentSolutionAdded(
            _assignmentId,
            assignmentSolutionId,
            _studentId
        );
    }

    function addAssignment(
        uint256 _class,
        string memory _subject,
        string memory _file,
        string memory _topic,
        uint256 _expiry
    ) public {
        uint256 assignmentId = schoolFiles.addAssignment(
            _class,
            _subject,
            _file,
            _topic,
            _expiry
        );
        emit assignmentAdded(assignmentId, _class, _expiry);
    }

    function addMarksCard(
        uint256 _studentId,
        uint256 _class,
        string memory _file,
        uint256 _expiry
    ) public {
        uint256 _marksCardId = schoolFiles.addMarksCard(
            _studentId,
            _class,
            _file,
            _expiry
        );
        emit marksCardAdded(_marksCardId, _studentId, _expiry);
    }

    function addTimeTable(
        uint256 _class,
        string memory _exam,
        string memory _file,
        uint256 _uploadTime
    ) public {
        schoolFiles.addTimeTable(_class, _exam, _file, _uploadTime);
    }

    function getAssignmentSolutionData(uint256 _assignmentSolutionId)
        public
        view
        isAdmin
        returns (
            string memory file,
            uint256 assignmentId,
            uint256 studentId
        )
    {
        string memory _file = schoolFiles.assignmentSolutionIdTofile(
            _assignmentSolutionId
        );
        uint256 _assignmentId = schoolFiles.assignmentSolutionIdToAssignmentId(
            _assignmentSolutionId
        );
        uint256 _studentId = schoolFiles.assignmentSolutionIdToStudentId(
            _assignmentSolutionId
        );
        return (_file, _assignmentId, _studentId);
    }

    function getAssignmentData(uint256 _assignmentId)
        public
        view
        isAdmin
        returns (
            string memory subject,
            string memory topic,
            string memory file,
            uint256 class,
            uint256 expiry
        )
    {
        string memory _subject = schoolFiles.assignmentIdTosubject(
            _assignmentId
        );
        string memory _topic = schoolFiles.assignmentIdToTopic(_assignmentId);
        string memory _file = schoolFiles.assignmentIdTofile(_assignmentId);
        uint256 _class = schoolFiles.assignmentIdToclass(_assignmentId);
        uint256 _expiry = schoolFiles.assignmentIdToExpiry(_assignmentId);
        return (_subject, _topic, _file, _class, _expiry);
    }

    function getMarksCardData(uint256 _marksCardId)
        public
        view
        isAdmin
        returns (
            uint256 studentId,
            uint256 class,
            string memory file
        )
    {
        uint256 _studentId = schoolFiles.marksCardIdTostudentId(_marksCardId);
        uint256 _class = schoolFiles.marksCardIdToclass(_marksCardId);
        string memory _file = schoolFiles.marksCardIdTofile(_marksCardId);
        return (_studentId, _class, _file);
    }

    function viewClassTimeTable(uint256 _class)
        public
        view
        isAdmin
        returns (string memory timeTableFile, uint256 uploadTime)
    {
        uint256 timetableCount = schoolFiles.timetableCount();
        for (
            uint256 timeTableId = timetableCount;
            timeTableId > 0;
            timeTableId--
        ) {
            if (
                schoolFiles.timeTableIdToclass(timeTableId) == _class &&
                keccak256(
                    abi.encodePacked(schoolFiles.timeTableIdToexam(timeTableId))
                ) ==
                keccak256(abi.encodePacked(""))
            ) {
                {
                    return (
                        schoolFiles.timeTableIdTofile(timeTableId),
                        schoolFiles.timeTableIdToUploadTime(timeTableId)
                    );
                }
            }
        }
        return ("Time table not found", 0);
    }

    function viewExamTimeTable(uint256 _class)
        public
        view
        isAdmin
        returns (string memory timeTableFile, uint256 uploadTime)
    {
        uint256 timetableCount = schoolFiles.timetableCount();
        for (
            uint256 timeTableId = timetableCount;
            timeTableId > 0;
            timeTableId--
        ) {
            if (
                schoolFiles.timeTableIdToclass(timeTableId) == _class &&
                keccak256(
                    abi.encodePacked(schoolFiles.timeTableIdToexam(timeTableId))
                ) !=
                keccak256(abi.encodePacked(""))
            ) {
                {
                    return (
                        schoolFiles.timeTableIdTofile(timeTableId),
                        schoolFiles.timeTableIdToUploadTime(timeTableId)
                    );
                }
            }
        }
        return ("Time table not found", 0);
    }

    function loginCheck(string memory _name, string memory _password)
        public
        view
        returns (string memory _loginType, uint256 _id)
    {
        (_loginType, _id) = login.loginCheck(_name, _password);
        return (_loginType, _id);
    }

    function markAttendance(
        uint256 _studentId,
        uint256 _attendanceValue,
        uint256 _date
    ) public isAdmin {
        attendance.markAttendance(_studentId, _attendanceValue, _date);
        emit attendanceMarked(_studentId, _attendanceValue, _date);
    }
}
