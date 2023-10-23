from config import db
from flask import abort, make_response
from models import Transaction, transaction_schema, transactions_schema

from io import BytesIO
import pandas as pd


def upload_file(file):
    # convert from byte string to the dataframe
    col_names = ["date", "cost", "desc", "balance"]
    df = pd.read_csv(BytesIO(file), names=col_names, header=None)

    # naive front and back check to see that the transaction ranges don't already
    # exist... This is stupid because the middle part could be... anyways.
    date = df["date"].iloc[0]
    desc = df["desc"].iloc[0]
    cost = df["cost"].iloc[0]
    balance = df["balance"].iloc[0]

    first_transaction_from_csv = Transaction.query.filter(
        Transaction.date == date,
        Transaction.desc == desc,
        Transaction.cost == cost,
        Transaction.balance == balance,
    ).one_or_none()

    date = df["date"].iloc[-1]
    desc = df["desc"].iloc[-1]
    cost = df["cost"].iloc[-1]
    balance = df["balance"].iloc[-1]

    last_transaction_from_csv = Transaction.query.filter(
        Transaction.date == date,
        Transaction.desc == desc,
        Transaction.cost == cost,
        Transaction.balance == balance,
    ).one_or_none()

    if first_transaction_from_csv is None and last_transaction_from_csv is None:
        print("uwu", df)
        for i, row in df.iterrows():
            print(row["balance"], row["cost"])
            new_transaction = {
                "date": row["date"],
                "desc": row["desc"],
                "cost": row["cost"],
                "balance": row["balance"],
            }

            new_transaction = transaction_schema.load(
                new_transaction, session=db.session
            )
            db.session.add(new_transaction)
            db.session.commit()
        return transaction_schema.dump(new_transaction), 201
    else:
        abort(406, f"Duplicate transaction found - aborting")