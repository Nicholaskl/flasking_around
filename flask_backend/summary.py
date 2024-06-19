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

    incomes = (
        db.session.query(func.sum(Transaction.cost).label("income"))
        .filter(Transaction.date >= date_start, Transaction.date <= date_end)
        .filter(Transaction.cost >= 0)
        .group_by(Transaction.category)
        .all()
    )
    spendings = (
        db.session.query(Transaction.category, func.sum(Transaction.cost))
        .filter(Transaction.date >= date_start, Transaction.date <= date_end)
        .filter(Transaction.cost < 0)
        .group_by(Transaction.category)
        .all()
    )
    # saving =

    balances = (
        db.session.query(Transaction.account, Transaction.balance)
        .filter(Transaction.balance > 0)
        .group_by(Transaction.account)
        .all()
    )

    income = extract_items(incomes)
    spending = extract_items(spendings)
    balance = extract_items(balances)

    export = {"income": income, "spending": spending, "balance": balance}
    return export, 201


def extract_items(list_of_rows):
    export = {}
    for item in list_of_rows:
        export.update(item._mapping)
    return export
