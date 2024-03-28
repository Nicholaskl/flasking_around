from flask import abort, make_response
from flask import abort, make_response
from models import Account, account_schema, accounts_schema


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
