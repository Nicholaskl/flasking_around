from config import db
from flask import abort, make_response
from datetime import datetime
from models import (
    Transaction,
    transaction_schema,
    transactions_schema,
    Account,
    Filter,
    filters_schema,
)
from accounts import read_one

from io import BytesIO
import pandas as pd


def upload_file(account_id_query, file):
    # print(file)
    if read_one(account_id_query) is None:
        abort(404, f"Account bad")

    # convert from byte string to the dataframe
    col_names = ["date", "cost", "desc", "balance"]
    df = pd.read_csv(BytesIO(file), names=col_names, header=None)
    df["balance"].fillna("0.00", inplace=True)

    # naive front and back check to see that the transaction ranges don't already
    # exist... This is stupid because the middle part could be... anyways.
    date = df["date"].iloc[0]
    desc = df["desc"].iloc[0]
    cost = df["cost"].iloc[0]
    balance = df["balance"].iloc[0]

    first_transaction_from_csv = Transaction.query.filter(
        Transaction.account == account_id_query,
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
        Transaction.account == account_id_query,
        Transaction.date == date,
        Transaction.desc == desc,
        Transaction.cost == cost,
        Transaction.balance == balance,
    ).one_or_none()

    filters = Filter.query.all()
    filters = filters_schema.dump(filters)

    if filters is None:
        abort(406, f"No filters found")
    else:
        df["category"] = ""

        for filter in filters:
            df["category"] = df["category"].mask(
                df["desc"].str.contains(filter["searchterm"]), filter["category"]
            )

        # Since it is a dataframe we can apply regex and search for things
        # Maybe match against a database that we keep - that we can edit in the UI
        # Look for "MCdonalds" and then give it the food category or something
        # Maybe if ABNs or something we can implement a search if it hasn't been seen before
        # Use some API or whatever
        if first_transaction_from_csv is None and last_transaction_from_csv is None:
            for i, row in df.iterrows():
                date_formatted = datetime.strptime(row["date"], "%d/%m/%Y")
                date_formatted = date_formatted.strftime("%Y/%m/%d")

                new_transaction = {
                    "accounts": account_id_query,
                    "date": date_formatted,
                    "desc": row["desc"],
                    "cost": row["cost"],
                    "balance": row["balance"],
                    "category": "Other",
                }

                # If it has a category
                if row["category"] != "":
                    new_transaction["category"] = row["category"]

                new_transaction = transaction_schema.load(
                    new_transaction, session=db.session
                )
                db.session.add(new_transaction)
                db.session.commit()
            return transaction_schema.dump(new_transaction), 201
        else:
            abort(406, f"Duplicate transaction found - aborting")
