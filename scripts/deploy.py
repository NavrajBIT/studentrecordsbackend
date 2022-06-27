from eth_account import Account
from scripts.tools import get_account
from brownie import (
    SchoolAdmin,
    StudentData,
    Login,
    SchoolFiles,
    Attendance,
    Modification,
    Performance,
)
from web3 import Web3
import json
from brownie import chain
import time
from scripts.sampleData import studentData
from scripts.poppulateDatabase import poppulatedata

contract_data = {"mainContract": ""}


def deploy():
    account = get_account()
    student_data_contract = StudentData.deploy({"from": account})
    login_contract = Login.deploy({"from": account})
    files_contract = SchoolFiles.deploy({"from": account})
    attendance_contract = Attendance.deploy({"from": account})
    modification_contract = Modification.deploy({"from": account})
    performance_contract = Performance.deploy({"from": account})
    admin_contract = SchoolAdmin.deploy(
        student_data_contract.address,
        files_contract.address,
        login_contract.address,
        attendance_contract.address,
        modification_contract.address,
        performance_contract.address,
        {"from": account},
    )

    owner_set_tx = student_data_contract.setOwner(admin_contract.address)
    owner_set_tx.wait(1)
    owner_set_tx = login_contract.setOwner(admin_contract.address)
    owner_set_tx.wait(1)
    owner_set_tx = files_contract.setOwner(admin_contract.address)
    owner_set_tx.wait(1)
    owner_set_tx = attendance_contract.setOwner(admin_contract.address)
    owner_set_tx.wait(1)
    owner_set_tx = modification_contract.setOwner(admin_contract.address)
    owner_set_tx.wait(1)
    owner_set_tx = performance_contract.setOwner(admin_contract.address)
    owner_set_tx.wait(1)

    admin1 = get_account(0)
    admin2 = get_account(1)
    admin3 = get_account(2)

    owner_set_tx = login_contract.setOwner(admin2, {"from": account})
    owner_set_tx.wait(1)
    owner_set_tx = login_contract.setOwner(admin3, {"from": account})
    owner_set_tx.wait(1)
    owner_set_tx = admin_contract.setAdmin(admin2, {"from": account})
    owner_set_tx.wait(1)
    owner_set_tx = admin_contract.setAdmin(admin3, {"from": account})
    owner_set_tx.wait(1)

    tx = login_contract.addAdmin("Admin1", "Admin1", {"from": admin1})
    tx.wait(1)
    tx = login_contract.addAdmin("Admin2", "Admin2", {"from": admin2})
    tx.wait(1)
    tx = login_contract.addSuperAdmin("SuperAdmin1", "SuperAdmin1", {"from": admin3})
    tx.wait(1)

    # poppulatedata()

    tx = login_contract.addStudent("student1", "1234", 1, {"from": account})
    tx.wait(1)
    tx = login_contract.addStudent("student2", "1234", 2, {"from": account})
    tx.wait(1)

    contract_data["mainContract"] = admin_contract.address
    save_data()


def save_data():
    with open(
        "./Frontend/Frontend2/studentrecords/api/contractData.json", "w"
    ) as outfile:
        json.dump(contract_data, outfile)
    main_contract_compiled = json.load(open("./build/contracts/SchoolAdmin.json"))
    with open(
        "./Frontend/Frontend2/studentrecords/api/compiledContract.json", "w"
    ) as outfile:
        json.dump(main_contract_compiled, outfile)


def main():
    deploy()
