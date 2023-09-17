from datetime import datetime
from flask import abort, make_response


def get_timestamp():
    return datetime.now().strftime(("%Y-%m-%d %H:%M:%S"))


TRANSACTIONS = {
    "0": {
        "date": datetime.strptime("01/01/2000", "%d/%m/%Y"),
        "desc": "Beem it",
        "cost": "-69.42",
    }
}


def read_all():
    return list(TRANSACTIONS.values())


def add(transaction):
    date = transaction.get("date")
    desc = transaction.get("desc")
    cost = transaction.get("cost")
    transaction_hash = hash((date, desc, cost))

    if transaction_hash not in TRANSACTIONS:
        TRANSACTIONS[transaction_hash] = {
            "date": date,
            "desc": desc,
            "cost": cost,
        }

        return make_response(
            f"{transaction} successfully added with id {transaction_hash}", 201
        )

    else:
        abort(
            406,
            f"Transaction with id {transaction_hash} already exists",
        )


def read_one(id):
    if id in TRANSACTIONS:
        return TRANSACTIONS[id]
    else:
        abort(404, f"Transaction with id {id} not found")


def update(id, transaction):
    date = transaction.get("date")
    desc = transaction.get("desc")
    cost = transaction.get("cost")

    if id in TRANSACTIONS:
        TRANSACTIONS[id]["date"] = date
        TRANSACTIONS[id]["desc"] = desc
        TRANSACTIONS[id]["cost"] = cost
        return TRANSACTIONS[id]
    else:
        abort(404, f"Transaction with id {id} not found")


def delete(id):
    if id in TRANSACTIONS:
        del TRANSACTIONS[id]
        return make_response(f"{id} successfully deleted", 200)
    else:
        abort(404, f"Transaction with id {id} not found")
