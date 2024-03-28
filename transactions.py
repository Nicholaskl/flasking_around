from config import db
from flask import abort, make_response
from models import Transaction, transaction_schema, transactions_schema


# def get_timestamp():
#     return datetime.now().strftime(("%Y-%m-%d %H:%M:%S"))


def read_all():
    transactions = Transaction.query.all()
    return transactions_schema.dump(transactions)


def clear():
    transcations = Transaction.query.all()
    for transaction in transcations:
        db.session.delete(transaction)

    db.session.commit()
    return make_response(f"Database was cleared", 200)
    # else:
    #     abort(404, f"Databse already clear")


def add(transaction):
    print(type(transaction))
    date = transaction.get("date")
    desc = transaction.get("desc")
    cost = transaction.get("cost")
    balance = transaction.get("balance")

    existing_transaction = Transaction.query.filter(
        Transaction.date == date,
        Transaction.desc == desc,
        Transaction.cost == cost,
        Transaction.balance == balance,
    ).one_or_none()

    if existing_transaction is None:
        new_transaction = transaction_schema.load(transaction, session=db.session)
        db.session.add(new_transaction)
        db.session.commit()
        return transaction_schema.dump(new_transaction), 201
    else:
        abort(406, f"Transaction with those details already exists")


def read_one(id):
    # person = Person.query.filter(Person.lname == lname).one_or_none()
    transaction = Transaction.query.filter(Transaction.id == id).one_or_none()

    if transaction is not None:
        return transaction_schema.dump(transaction)
    else:
        abort(404, f"Transcation with the id: {id} was not found")


def update(id, transaction):
    existing_transaction = Transaction.query.filter(Transaction.id == id).one_or_none()

    if existing_transaction:
        update_transaction = transaction_schema.load(transaction, session=db.session)
        existing_transaction.fname = update_transaction.fname
        db.session.merge(existing_transaction)
        db.session.commit()
        return transaction_schema.dump(existing_transaction), 201
    else:
        abort(404, f"Transaction with the id: {id} not found")


def delete(id):
    existing_transaction = Transaction.query.filter(Transaction.id == id).one_or_none()

    if existing_transaction:
        db.session.delete(existing_transaction)
        db.session.commit()
        return make_response(f"{id} successfully deleted", 200)
    else:
        abort(404, f"Transaction with the id: {id} not found")


def search_desc(desc):
    # transactions = Transaction.desc.contains(desc).all()
    transactions = Transaction.query.filter(Transaction.desc.contains(desc)).all()

    if len(transactions) != 0:
        return transactions_schema.dump(transactions)
    else:
        abort(404, f"Transcation with the id: {id} was not found")
