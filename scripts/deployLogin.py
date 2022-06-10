from eth_account import Account
from scripts.tools import get_account
from brownie import Login, config
from web3 import Web3
import json
from brownie import chain
import time

contract_data = {"loginContract": ""}


def deploy():
    account = get_account()
    login_contract = Login.deploy({"from": account})
    tx1 = login_contract.addAdmin("Rakesh", "Admin1", {"from": account})
    tx1.wait(1)
    tx2 = login_contract.addStudent("Mukesh", "Student1", {"from": account})
    tx2.wait(1)
    contract_data["mainContract"] = login_contract.address
    save_data()


def save_data():
    with open("./Frontend/apitest/contractData.json", "w") as outfile:
        json.dump(contract_data, outfile)
    main_contract_compiled = json.load(open("./build/contracts/Login.json"))
    with open("./Frontend/apitest/compiledContract.json", "w") as outfile:
        json.dump(main_contract_compiled, outfile)


def main():
    deploy()
