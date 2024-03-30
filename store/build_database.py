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
            ("06/01/2022", "Description number 1", 9.99, 10.25),
            ("05/03/2022", "Description number 2", 63.26, 134.5),
            ("05/03/2022", "Description number 3", 929.3, 1361.5),
            #         date = db.Column(db.String(32))
            # desc = db.Column(db.String(255))
            # cost = db.Column(db.Float)
            # balance = db.Column(db.Float)
        ],
    },
    {
        "nickname": "Main saving",
        "bank_name": "CBA",
        "account_type": "Saving",
        "rel_transactions": [
            ("04/01/2022", "Description number 4", 246.2, 235.23),
            ("09/03/2022", "Description number 5", 46.3, 46.2),
            #         date = db.Column(db.String(32))
            # desc = db.Column(db.String(255))
            # cost = db.Column(db.Float)
            # balance = db.Column(db.Float)
        ],
    },
    {
        "nickname": "Long term spending",
        "bank_name": "Westpac",
        "account_type": "Spending",
        "rel_transactions": [
            ("06/01/2022", "Description number 6", 26.2, 57.3),
            ("03/03/2022", "Description number 7", 6458.4, 769.5),
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
