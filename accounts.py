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


def read_all():
    accounts = Account.query.all()
    return accounts_schema.dump(accounts)


def read_one(account_id):
    # person = Person.query.filter(Person.lname == lname).one_or_none()
    account = Account.query.filter(Account.id == account_id).one_or_none()

    if account is not None:
        return account_schema.dump(account)
    else:
        abort(404, f"Transcation with the id: {account_id} was not found")


def getTransactions(account_list):
    for account_id in account_list:
        account = Account.query.filter(Account.id == account_id).one_or_none()
        if account is None:
            abort(404, f"Invalid account: {account_id} found in list")

    transactions = Transaction.query.join(Account).where(Account.id.in_(account_list))
    return transactions_schema.dump(transactions)


# session.query(Address).select_from(User).\
#         join(User.addresses).\
#         filter(User.name == 'ed')
