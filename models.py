from config import db, ma


class Transaction(db.Model):
    __tablename__ = "transactions"

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    date = db.Column(db.String(32))
    desc = db.Column(db.String(255))
    cost = db.Column(db.Float)
    balance = db.Column(db.Float)


class TransactionSchema(ma.SQLAlchemyAutoSchema):
    class Meta:
        model = Transaction
        load_instance = True
        sqla_session = db.session


transaction_schema = TransactionSchema()
transactions_schema = TransactionSchema(many=True)
