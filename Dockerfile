FROM python:3.6-buster

RUN echo "deb http://archive.debian.org/debian/ buster main" > /etc/apt/sources.list \
    && echo "deb-src http://archive.debian.org/debian/ buster main" >> /etc/apt/sources.list \
    && echo "Acquire::Check-Valid-Until false;" > /etc/apt/apt.conf.d/99no-check-valid-until \
    && apt-get update \
    && apt-get install -y \
       build-essential \
       python3-dev \
       libpq-dev \
       libjpeg-dev \
       zlib1g-dev \
       libffi-dev \
       libssl-dev \
       curl \
       nodejs \
       npm \
       python2 \
    && rm -rf /var/lib/apt/lists/* \
    && npm install -g yarn \
    && npm config set python python2 \
    && yarn config set python python2

WORKDIR /app

COPY requirements.txt /app/

RUN pip install "pip<21.0" "setuptools<45.0.0" "wheel<0.37.0" "Cython<3.0" \
    && pip install -r requirements.txt

COPY . /app/

RUN groupadd -r appuser && useradd -r -g appuser appuser

RUN chown -R appuser:appuser /app

USER appuser
