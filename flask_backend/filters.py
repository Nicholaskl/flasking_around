from config import db
from flask import abort, make_response
from models import Filter, filter_schema, filters_schema


def read_all():
    transactions = Filter.query.all()
    return filters_schema.dump(transactions)


def clear():
    transcations = Filter.query.all()
    for transaction in transcations:
        db.session.delete(transaction)

    db.session.commit()
    return make_response(f"Database was cleared", 200)


def add(filter):
    print(type(filter))
    searchterm = filter.get("searchterm")
    category = filter.get("category")

    existing_filter = Filter.query.filter(
        Filter.searchterm == searchterm,
        Filter.category == category,
    ).one_or_none()

    if existing_filter is None:
        new_filter = filter_schema.load(filter, session=db.session)
        db.session.add(new_filter)
        db.session.commit()
        return filter_schema.dump(new_filter), 201
    else:
        abort(406, f"Filter with those details already exists")


def read_one(id):
    # person = Person.query.filter(Person.lname == lname).one_or_none()
    filter = Filter.query.filter(Filter.id == id).one_or_none()

    if filter is not None:
        return filter_schema.dump(filter)
    else:
        abort(404, f"Filter with the id: {id} was not found")


def delete(id):
    existing_filter = Filter.query.filter(Filter.id == id).one_or_none()

    if existing_filter:
        db.session.delete(existing_filter)
        db.session.commit()
        return make_response(f"{id} successfully deleted", 200)
    else:
        abort(404, f"Filter with the id: {id} not found")
