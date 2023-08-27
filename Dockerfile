# syntax=docker/dockerfile:1

FROM python:3.9-slim

RUN mkdir /var/www
RUN cd /var/www
RUN mkdir /var/www/uploads
COPY . ./var/www

RUN pip3 install -r /var/www/requirements.txt

ENV FLASK_APP=app
EXPOSE 8000
CMD flask --app /var/www/app run --host 0.0.0.0 --port 8000