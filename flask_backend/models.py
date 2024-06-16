from config import db, ma
from marshmallow_sqlalchemy import fields


class Transaction(db.Model):
    __tablename__ = "transactions"

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    account = db.Column(db.Integer, db.ForeignKey("accounts.id"), nullable=False)
    date = db.Column(db.String(32))
    desc = db.Column(db.String(255))
    cost = db.Column(db.Float)
    balance = db.Column(db.Float)
    category = db.Column(db.String(64), nullable=True)


class Account(db.Model):
    __tablename__ = "accounts"

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    nickname = db.Column(db.String(32))
    bank_name = db.Column(db.String(32))
    account_type = db.Column(db.String(32))
    rel_transactions = db.relationship(
        Transaction,
        backref="accounts",
        cascade="all, delete, delete-orphan",
        single_parent=True,
        order_by="desc(Transaction.date)",
    )


class Filter(db.Model):
    __tablename__ = "filters"

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    searchterm = db.Column(db.String(64))
    category = db.Column(db.String(64))


class TransactionSchema(ma.SQLAlchemyAutoSchema):
    class Meta:
        model = Transaction
        load_instance = True
        sqla_session = db.session
        include_relationships = True


class AccountSchema(ma.SQLAlchemyAutoSchema):
    class Meta:
        model = Account
        load_instance = True
        sqla_session = db.session
        include_fk = True

    transactions = fields.Nested(TransactionSchema, many=True)


class FilterSchema(ma.SQLAlchemyAutoSchema):
    class Meta:
        model = Filter
        load_instance = True
        sqla_session = db.session
        include_relationships = True


transaction_schema = TransactionSchema()
transactions_schema = TransactionSchema(many=True)
account_schema = AccountSchema()
accounts_schema = AccountSchema(many=True)
filter_schema = FilterSchema()
filters_schema = FilterSchema(many=True)
