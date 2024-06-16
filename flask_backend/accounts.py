from flask import abort, make_response
from sqlalchemy import select
from models import (
    Account,
    account_schema,
    accounts_schema,
    Transaction,
    transaction_schema,
    transactions_schema,
)
from config import db

VALID_ACCOUNT_TYPES = ["Savings", "Spending", "Credit"]


def read_all():
    accounts = Account.query.all()
    return accounts_schema.dump(accounts)


def read_one(account_id):
    # person = Person.query.filter(Person.lname == lname).one_or_none()
    account = Account.query.filter(Account.id == account_id).one_or_none()

    if account is not None:
        return account_schema.dump(account)
    else:
        abort(404, f"Account with the id: {account_id} was not found")


def getTransactions(account_list):
    for account_id in account_list:
        account = Account.query.filter(Account.id == account_id).one_or_none()
        if account is None:
            abort(404, f"Invalid account: {account_id} found in list")

    transactions = Transaction.query.join(Account).where(Account.id.in_(account_list))
    return transactions_schema.dump(transactions)


def clear():
    accounts = Account.query.all()
    for account in accounts:
        db.session.delete(account)

    db.session.commit()
    return make_response(f"Database was cleared", 200)


def add(account):
    nickname = account.get("nickname")
    account_type = account.get("account_type")

    existing_account = Account.query.filter(
        Account.nickname == nickname,
    ).one_or_none()

    if account_type not in VALID_ACCOUNT_TYPES:
        abort(406, f"Not a valid account type")
    elif existing_account is None:
        new_account = account_schema.load(account, session=db.session)
        db.session.add(new_account)
        db.session.commit()
        return account_schema.dump(new_account), 201
    else:
        abort(406, f"Account with those details already exists")


def read_all_summary():
    # Might want something here that looks for only spending / saving acounts
    # Since... well crdit accounts don't have a balance.
    transactions = Transaction.query.group_by(Transaction.account).all()
    print(transactions)
    return transactions_schema.dump(transactions)


# session.query(Address).select_from(User).\
#         join(User.addresses).\
#         filter(User.name == 'ed')
