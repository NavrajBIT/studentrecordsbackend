from eth_account import Account
from scripts.tools import get_account
from brownie import SchoolAdmin, StudentData, Login, SchoolFiles, Attendance
from web3 import Web3
import json
from brownie import chain
import time
from scripts.sampleData import studentData


def poppulatedata():
    account = get_account()
    login_contract = Login[-1]
    admin_contract = SchoolAdmin[-1]
    studentId = 0
    for student in studentData:
        studentId = studentId + 1
        userName = "student" + str(studentId)
        tx = login_contract.addStudent(userName, "1234", studentId, {"from": account})
        tx = admin_contract.addStudent(
            student["studentName"],
            student["dob"],
            student["rollNumber"],
            student["grade"],
            student["email"],
            {"from": account},
        )
        tx.wait(1)

        tx = admin_contract.addPersonalDetails(
            studentId,
            student["religion"],
            student["caste"],
            student["nationality"],
            student["aadharNumber"],
            student["gender"],
            {"from": account},
        )
        tx.wait(1)

        tx = admin_contract.addPaternalDetails(
            studentId,
            student["fatherName"],
            student["currentAddress"],
            student["officeAddress"],
            student["fatherOccupation"],
            student["fatherEducation"],
            {"from": account},
        )
        tx.wait(1)

        tx = admin_contract.addMaternalDetails(
            studentId,
            student["motherName"],
            student["motherOccupation"],
            student["motherEducation"],
            {"from": account},
        )
        tx.wait(1)

        tx = admin_contract.addGuardianDetails(
            studentId,
            student["guardianName"],
            student["guardianAddress"],
            {"from": account},
        )
        tx.wait(1)

        tx = admin_contract.addFamilyDetails(
            studentId,
            student["familyIncome"],
            student["primaryContact"],
            student["secondaryContact"],
            {"from": account},
        )
        tx.wait(1)

        tx = admin_contract.addFiles(
            studentId,
            student["uploadAadharFront"],
            student["uploadAadharBack"],
            student["uploadIncomeCertificate"],
            student["uploadBirthCertificate"],
            student["uploadCasteCertificate"],
            {"from": account},
        )
        tx.wait(1)

        tx = admin_contract.addNonAcademic(
            studentId,
            student["sportsInvolved"],
            student["sportsAchievements"],
            student["extraCurricullum"],
            student["extraCurricullumAchievements"],
            student["personalityDevelopment"],
            student["personalityDevelopmentAchievements"],
            {"from": account},
        )
        tx.wait(1)
