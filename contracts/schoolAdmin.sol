// SPDX-License-Identifier: MIT

pragma solidity 0.8.14;

import "./studentData.sol";
import "./schoolFiles.sol";
import "./login.sol";

contract SchoolAdmin {
    StudentData studentData;
    SchoolFiles schoolFiles;
    Login login;
    address public admin;
    uint256 public maleStudents;
    uint256 public femaleStudents;

    event studentAdded(uint256 indexed _studentId, uint256 indexed _dob);
    event studentFound(uint256 indexed _studentId, uint256 indexed _rollNumber);
    event assignmentAdded(uint256 indexed _assignmentId, uint256 indexed _class);

    constructor(
        address _studentData,
        address _schoolFiles,
        address _login
    ) {
        studentData = StudentData(_studentData);
        schoolFiles = SchoolFiles(_schoolFiles);
        login = Login(_login);
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

    function getStudentPrimaryData(uint256 _studentId)
        public
        view
        isAdmin
        returns (
            string memory name,
            uint256 rollNumber,
            uint256 dob,
            string memory gender
        )
    {
        return studentData.studentIdToPrimaryDetails(_studentId);
    }
    
    function getStudentSchoolDetails(uint256 _studentId) public view isAdmin returns (
            uint256 _class,
        string memory _email,
        uint256 _batch
        ) {
           return studentData.studentIdToSchoolDetails(_studentId); 
        }
    function getPersonalDetails(uint256 _studentId) public view isAdmin returns (
           string memory currentAddress,
        string memory caste,
        string memory nationality
        ) {
           return studentData.studentIdToPersonalDetails(_studentId); 
        }
    function getParentalDetails(uint256 _studentId) public view isAdmin returns (
           string memory guardianName,
        string memory fatherName,
        string memory motherName,
        string memory educationFather,
        string memory educationMother
        ) {
           return studentData.studentIdToParentalDetails(_studentId); 
        }




    function addStudent(
        string memory _name,
        uint256 _rollNumber,
        uint256 _dob,
        string memory _gender
    ) public isAdmin {
        if (
            keccak256(abi.encodePacked(_gender)) ==
            keccak256(abi.encodePacked("male"))
        ) {
            maleStudents = maleStudents + 1;
        } else {
            femaleStudents = femaleStudents + 1;
        }
        uint256 _studentId = studentData.addStudent(
            _name,
            _rollNumber,
            _dob,
            _gender
        );
        emit studentAdded(_studentId, _dob);
    }

    function modifyPrimaryDetails(
        uint256 _studentId,
        string memory _name,
        uint256 _rollNumber,
        uint256 _dob,
        string memory _gender
    ) public isAdmin {
        studentData.modifyPrimaryDetails(
            _studentId,
            _name,
            _rollNumber,
            _dob,
            _gender
        );
    }

    function schoolDetails(
        uint256 _studentId,
        uint256 _class,
        string memory _email,
        uint256 _batch
    ) public isAdmin {
        studentData.schoolDetails(_studentId, _class, _email, _batch);
    }

    
    function personalDetails(
        uint256 _studentId,
        string memory _currentAddress,
        string memory _caste,
        string memory _nationality
    ) public isAdmin {
        studentData.personalDetails(
            _studentId,
            _currentAddress,
            _caste,
            _nationality
        );
    }

    function parentalDetails(
        uint256 _studentId,
        string memory _guardianName,
        string memory _fatherName,
        string memory _MotherName,
        string memory _educationFather,
        string memory _educationMother
    ) public isAdmin {
        studentData.parentalDetails(
            _studentId,
            _guardianName,
            _fatherName,
            _MotherName,
            _educationFather,
            _educationMother
        );
    }

    function searchStudent(
        string memory _name,
        uint256 _rollnumber        
    ) public isAdmin {
        uint256 studentCount = getStudentCount();
        for (uint256 studentId = 1; studentId <= studentCount; studentId++) {
            (string memory studentName, uint256 studentRollNumber,,) = studentData.studentIdToPrimaryDetails(studentId);
            if (keccak256(abi.encodePacked(studentName)) == keccak256(abi.encodePacked(_name))) {
                if (studentRollNumber == _rollnumber) {
                    emit studentFound(studentId, studentRollNumber);
                }
             
            }
        }
    }

    function addAssignment(
        uint256 _class,
        string memory _subject,
        string memory _file,
        string memory _topic
    ) public {
        uint256 assignmentId = schoolFiles.addAssignment(_class, _subject, _file, _topic);
        emit assignmentAdded(assignmentId, _class);
    }

    function addMarksCard(
        uint256 _studentId,
        uint256 _class,
        string memory _file
    ) public {
        schoolFiles.addMarksCard(_studentId, _class, _file);
    }

    function addTimeTable(
        uint256 _class,
        string memory _exam,
        string memory _file
    ) public {
        schoolFiles.addTimeTable(_class, _exam, _file);
    }

    function viewAssignment(uint256 _class, string memory _subject, string memory _topic)
        public
        view
        isAdmin
        returns (string memory assignmentFile)
    {
        uint256 assignmentCount = schoolFiles.assignmentCount();
        for (
            uint256 assignmentId = assignmentCount;
            assignmentId > 0;
            assignmentId--
        ) {
            if (schoolFiles.assignmentIdToclass(assignmentId) == _class) {
                if (
                    keccak256(
                        abi.encodePacked(
                            schoolFiles.assignmentIdTosubject(assignmentId)
                        )
                    ) == keccak256(abi.encodePacked(_subject))
                ) {
                    if (keccak256(abi.encodePacked(_topic)) == keccak256(abi.encodePacked(schoolFiles.assignmentIdToTopic(assignmentId)))) {
                    return schoolFiles.assignmentIdTofile(assignmentId);
                    }
                }
            }
        }
        return "Assignment not found";
    }

    function getAssignmentData(uint256 _assignmentId) public view isAdmin returns (string memory subject, string memory topic, string memory file) {
        string memory _subject = schoolFiles.assignmentIdTosubject(_assignmentId);
        string memory _topic = schoolFiles.assignmentIdToTopic(_assignmentId);
        string memory _file = schoolFiles.assignmentIdTofile(_assignmentId);
        return (_subject, _topic, _file);
    }

    function viewClassTimeTable(uint256 _class)
        public
        view
        isAdmin
        returns (string memory timeTableFile)
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
                    return schoolFiles.timeTableIdTofile(timeTableId);
                }
            }
        }
        return "Time table not found";
    }

    function viewExamTimeTable(uint256 _class)
        public
        view
        isAdmin
        returns (string memory timeTableFile)
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
                    return schoolFiles.timeTableIdTofile(timeTableId);
                }
            }
        }
        return "Time table not found";
    }

    function viewMarksCard(uint256 _studentId, uint256 _class)
        public
        view
        isAdmin
        returns (string memory marksCardFile)
    {
        uint256 marksCardCount = schoolFiles.marksCardCount();
        for (
            uint256 marksCardId = marksCardCount;
            marksCardId > 0;
            marksCardId--
        ) {
            if (
                schoolFiles.marksCardIdToclass(marksCardId) == _class &&
                schoolFiles.marksCardIdTostudentId(marksCardId) == _studentId
            ) {
                {
                    return schoolFiles.marksCardIdTofile(marksCardId);
                }
            }
        }
        return "Marks card not found";
    }

    function loginCheck(string memory _name, string memory _password)
        public
        view
        returns (string memory _loginType, uint256 _id)
    {
        (_loginType, _id) = login.loginCheck(_name, _password);
        return (_loginType, _id);
    }
}
