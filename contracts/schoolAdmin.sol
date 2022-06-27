// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "./studentData.sol";
import "./schoolFiles.sol";
import "./login.sol";
import "./attendance.sol";
import "./modification.sol";
import "./academicPerformance.sol";

contract SchoolAdmin {
    StudentData studentData;
    SchoolFiles schoolFiles;
    Login login;
    Attendance attendance;
    Modification modification;
    Performance performance;

    uint256 public adminCount;
    mapping(address => uint256) public adminToAdminId;

    uint256 public maleStudents;
    uint256 public femaleStudents;
    mapping(uint256 => uint256) public gradeToNumberOfStudents;
    mapping(uint256 => mapping(string => uint256))
        private gradeToSectionToCount;

    event studentAdded(
        uint256 indexed _studentId,
        uint256 indexed _rollNumber,
        uint256 indexed _class
    );
    event modifiedPrimaryDetails(uint256 indexed _studentId);
    event modifiedPersonalDetails(uint256 indexed _studentId);
    event modifiedPaternalDetails(uint256 indexed _studentId);
    event modifiedMaternalDetails(uint256 indexed _studentId);
    event modifiedGuardianDetails(uint256 indexed _studentId);
    event modifiedFamilyDetails(uint256 indexed _studentId);
    event modifiedFiles(uint256 indexed _studentId);
    event modifiedNonAcademicDetails(uint256 indexed _studentId);
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
        address _attendance,
        address _modification,
        address _performance
    ) {
        studentData = StudentData(_studentData);
        schoolFiles = SchoolFiles(_schoolFiles);
        login = Login(_login);
        attendance = Attendance(_attendance);
        modification = Modification(_modification);
        performance = Performance(_performance);
        adminCount = 1;
        adminToAdminId[msg.sender] = adminCount;
    }

    modifier isAdmin() {
        require(adminToAdminId[msg.sender] > 0, "You are not the admin.");
        _;
    }

    function setAdmin(address _newAdmin) public isAdmin {
        require(adminToAdminId[_newAdmin] == 0, "Admin already added.");
        adminCount = adminCount + 1;
        adminToAdminId[_newAdmin] = adminCount;
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

    function getGenderKPI()
        public
        view
        isAdmin
        returns (
            uint256 totalNumber,
            uint256 maleNumber,
            uint256 femaleNumber
        )
    {
        uint256 _studentCount = studentData.studentCount();
        return (_studentCount, maleStudents, femaleStudents);
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
            string memory _section,
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
        string memory _section,
        string memory _email
    ) public isAdmin {
        uint256 _studentId = studentData.addStudent(
            _studentName,
            _dob,
            _rollNumber,
            _grade,
            _section,
            _email
        );
        gradeToNumberOfStudents[_grade] = gradeToNumberOfStudents[_grade] + 1;

        gradeToSectionToCount[_grade][_section] =
            gradeToSectionToCount[_grade][_section] +
            1;
        emit studentAdded(_studentId, _rollNumber, _grade);
    }

    function modifyPrimaryDetails(
        uint256 _studentId,
        string memory _studentName,
        uint256 _dob,
        uint256 _grade,
        string memory _section,
        string memory _email
    ) public isAdmin {
        (
            ,
            ,
            ,
            uint256 existingGrade,
            string memory existingSection,

        ) = studentData.studentIdToPrimaryDetails(_studentId);

        gradeToNumberOfStudents[existingGrade] =
            gradeToNumberOfStudents[existingGrade] -
            1;
        gradeToNumberOfStudents[_grade] = gradeToNumberOfStudents[_grade] + 1;

        gradeToSectionToCount[existingGrade][existingSection] =
            gradeToSectionToCount[existingGrade][existingSection] -
            1;
        gradeToSectionToCount[_grade][_section] =
            gradeToSectionToCount[_grade][_section] +
            1;

        studentData.modifyPrimaryDetails(
            _studentId,
            _studentName,
            _dob,
            _grade,
            _section,
            _email
        );
        emit modifiedPrimaryDetails(_studentId);
    }

    function addPersonalDetails(
        uint256 _studentId,
        string memory _religion,
        string memory _caste,
        string memory _nationality,
        uint256 _aadharNumber,
        string memory _gender
    ) public isAdmin {
        (, , , , string memory existingGender) = studentData
            .studentIdToPersonalDetails(_studentId);

        if (
            keccak256(abi.encodePacked(existingGender)) ==
            keccak256(abi.encodePacked("male"))
        ) {
            maleStudents = maleStudents - 1;
        }
        if (
            keccak256(abi.encodePacked(existingGender)) ==
            keccak256(abi.encodePacked("female"))
        ) {
            femaleStudents = femaleStudents - 1;
        }
        if (
            keccak256(abi.encodePacked(_gender)) ==
            keccak256(abi.encodePacked("male"))
        ) {
            maleStudents = maleStudents + 1;
        }
        if (
            keccak256(abi.encodePacked(_gender)) ==
            keccak256(abi.encodePacked("female"))
        ) {
            femaleStudents = femaleStudents + 1;
        }

        studentData.addPersonalDetails(
            _studentId,
            _religion,
            _caste,
            _nationality,
            _aadharNumber,
            _gender
        );
        emit modifiedPersonalDetails(_studentId);
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
        emit modifiedPaternalDetails(_studentId);
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
        emit modifiedMaternalDetails(_studentId);
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
        emit modifiedGuardianDetails(_studentId);
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
        emit modifiedFamilyDetails(_studentId);
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
        emit modifiedFiles(_studentId);
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
        emit modifiedNonAcademicDetails(_studentId);
    }

    function searchStudent(string memory _name, uint256 _class) public isAdmin {
        uint256 studentCount = getStudentCount();
        for (uint256 studentId = 1; studentId <= studentCount; studentId++) {
            (
                string memory studentName,
                ,
                uint256 studentRollNumber,
                uint256 studentClass,
                ,

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

    function getAdminData(address admin)
        public
        view
        isAdmin
        returns (string memory name, string memory _type)
    {
        return (login.walletToName(admin), login.walletToType(admin));
    }

    function markAttendance(
        uint256 _studentId,
        uint256 _attendanceValue,
        uint256 _date
    ) public isAdmin {
        attendance.markAttendance(_studentId, _attendanceValue, _date);
        emit attendanceMarked(_studentId, _attendanceValue, _date);
    }

    function getAttendance(uint256 _studentId, uint256 _date)
        public
        view
        isAdmin
        returns (uint256 attendanceMark)
    {
        return attendance.getAttendance(_studentId, _date);
    }

    function raiseRequest(
        uint256 _studentId,
        string memory _title,
        string memory _file,
        string memory _description
    ) public isAdmin {
        modification.raiseRequest(_studentId, _title, _file, _description);
    }

    function closeRequest(uint256 _requestId) public isAdmin {
        modification.closeRequest(_requestId);
    }

    function rejectRequest(uint256 _requestId) public isAdmin {
        modification.rejectRequest(_requestId);
    }

    function approveRequest(uint256 _requestId) public isAdmin {
        modification.approveRequest(_requestId);
    }

    function getRequestCount()
        public
        view
        isAdmin
        returns (
            uint256 requestCount,
            uint256 pendingRequestCount,
            uint256 rejectedRequestCount,
            uint256 approvedRequestCount,
            uint256 closedRequestCount
        )
    {
        return (
            modification.requestCount(),
            modification.pendingRequestCount(),
            modification.rejectedRequestCount(),
            modification.approvedRequestCount(),
            modification.closedRequestCount()
        );
    }

    function getRequestData(uint256 _requestId)
        public
        view
        returns (
            uint256 studentId,
            string memory title,
            string memory description,
            string memory file,
            string memory status
        )
    {
        uint256 _studentId = modification.requestIdToStudentId(_requestId);
        string memory _title = modification.requestIdTotitle(_requestId);
        string memory _description = modification.requestIdToDescription(
            _requestId
        );
        string memory _status = modification.requestIdToStatus(_requestId);
        string memory _file = modification.requestIdToFile(_requestId);
        return (_studentId, _title, _description, _file, _status);
    }

    function addPerformanceIndicator(
        uint256 _grade,
        uint256 _batch,
        uint256 _totalStudents,
        uint256 _passedStudents,
        uint256 _failedStudents
    ) public isAdmin {
        performance.addPerformanceIndicator(
            _grade,
            _batch,
            _totalStudents,
            _passedStudents,
            _failedStudents
        );
    }

    function getPerformanceIndicator(uint256 _batchId, uint256 _grade)
        public
        view
        isAdmin
        returns (
            uint256 batch,
            uint256 totalStudents,
            uint256 passedStudents,
            uint256 failedStudents
        )
    {
        uint256 _batch = performance.getBatchFromId(_grade, _batchId);
        (
            uint256 _totalStudents,
            uint256 _passedStudents,
            uint256 _failedStudents
        ) = performance.getPerformanceIndicator(_batch, _grade);
        return (_batch, _totalStudents, _passedStudents, _failedStudents);
    }

    function getBatchCount(uint256 grade)
        public
        view
        isAdmin
        returns (uint256 batchCount)
    {
        return performance.gradeToBatchCount(grade);
    }

    function getStudentsInGradeSection(uint256 _grade, string memory _section)
        public
        view
        isAdmin
        returns (uint256 studentCount)
    {
        return gradeToSectionToCount[_grade][_section];
    }
}
