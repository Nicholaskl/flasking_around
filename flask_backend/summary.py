from config import db
from flask import abort, make_response
from models import Transaction, transaction_schema, transactions_schema
from sqlalchemy.sql import func


# def get_timestamp():
#     return datetime.now().strftime(("%Y-%m-%d %H:%M:%S"))


def read_all():
    transactions = Transaction.query.all()
    return transactions_schema.dump(transactions)


def getSummary(Date_Between):
    date_start = Date_Between.get("date_start")
    date_end = Date_Between.get("date_end")

    # return dictionary

    income = (
        db.session.query(func.sum(Transaction.cost))
        .filter(Transaction.date >= date_start, Transaction.date <= date_end)
        .filter(Transaction.cost >= 0)
        .group_by(Transaction.category)
        .all()
    )
    spending = (
        db.session.query(Transaction.category, func.sum(Transaction.cost))
        .filter(Transaction.date >= date_start, Transaction.date <= date_end)
        .filter(Transaction.cost < 0)
        .group_by(Transaction.category)
        .all()
    )
    # saving =

    balance = (
        db.session.query(Transaction.account, Transaction.balance)
        .filter(Transaction.balance > 0)
        .group_by(Transaction.account)
        .all()
    )

    print("income", income)
    print("spending", spending)
    print("balance", balance)
