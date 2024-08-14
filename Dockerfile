# Build Stage
FROM python:3.11.9-alpine3.20 as build

# Install dependencies
RUN apk update
WORKDIR /usr/src/owaspnettacker
COPY . .
RUN mkdir -p .data/results
RUN apk update
RUN apk add $(cat requirements-apk.txt)
RUN pip3 install --upgrade pip
RUN pip3 install -r requirements.txt
RUN pip3 install -r requirements-dev.txt

# Production Stage
FROM python:3.11.9-alpine3.20 as production

WORKDIR /usr/src/owaspnettacker
COPY --from=build /usr/src/owaspnettacker /usr/src/owaspnettacker
COPY --from=build /usr/local/lib/python3.11/site-packages /usr/local/lib/python3.11/site-packages

RUN pip3 install --upgrade setuptools==70
RUN pip3 install --upgrade requests==2.32.0
RUN pip3 install --upgrade cryptography==42.0.4

ENV docker_env=true
CMD [ "python3", "./nettacker.py" ]
