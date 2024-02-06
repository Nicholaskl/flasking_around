# Flasking Around Project

This is the readme file for a random Flask app I want to learn how to make. It uses a docker container to spin up a flask application so I don't have to muck around and do that haha.

## Building and running the docker container

First we have to build the docker container and give it a name:
```zsh
docker build -t test:latest .
```

And then we'll need to run it:
```zsh
docker run -p 127.0.0.1:8000:8000 test:latest
```

In order to run the frontend you will need to spin up the flutter stuff:
```zsh
flutter run -d chrome --web-browser-flag "--disable-web-security"
```

## Dependent packages

- **Flask**: This is the actual API package that is the backbone of the app itself
- **Pandas**: I'll be using this ot perform dat related tasks
- **SQLAlchemy**: Abstracts SQL queries so I don't have to use them raw - it's an ORM 😋

## Database(s)

### Transactions

This database contains information with every entry being the different transactions that have occurred. Currently the table looks like the following:

| Column Name | Data Type  | Extra       |
| ----------- | ---------- | ----------- |
| id          | INT        | Primary Key |
| date        | String(32) |             |
| desc        | String(32) |             |
| cost        | Float      |             |
| balance     | Float      |             |

Todo: I kinda also want to be able to relate different accounts and different pull apart the details of the payment to grab things such as categories and all that.... somehow.