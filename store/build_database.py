# build_database.py
import sys

sys.path.append("/Users/nicholaskh/Documents/randomCode/flasking_around/")
from datetime import datetime
from config import app, db
from models import Account, Transaction

ACCOUNTS = [
    {
        "nickname": "Main spending",
        "bank_name": "CBA",
        "account_type": "Spending",
        "rel_transactions": [
            ("2022-01-06 17:10:24", "Description number 1", 9.99, 10.25),
            ("2022-03-05 22:17:54", "Description number 2", 63.26, 134.5),
            ("2022-03-05 22:18:10", "Description number 3", 929.3, 1361.5),
            #         date = db.Column(db.String(32))
            # desc = db.Column(db.String(255))
            # cost = db.Column(db.Float)
            # balance = db.Column(db.Float)
        ],
    },
]

with app.app_context():
    db.drop_all()
    db.create_all()
    for data in ACCOUNTS:
        new_account = Account(
            nickname=data.get("nickname"),
            bank_name=data.get("bank_name"),
            account_type=data.get("account_type"),
        )
        for date, desc, cost, balance in data.get("rel_transactions", []):
            new_account.rel_transactions.append(
                Transaction(
                    date=date,
                    desc=desc,
                    cost=cost,
                    balance=balance,
                )
            )
        db.session.add(new_account)
    db.session.commit()
