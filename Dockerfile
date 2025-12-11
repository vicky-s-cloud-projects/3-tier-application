# FROM ubuntu:22.04
# ENV PYTHONDONTWRITEBYTECODE=1
# ENV PYTHONUNBUFFERED=1
# Avoid timezone prompts
# ENV DEBIAN_FRONTEND=noninteractive  
# WORKDIR /app
# Install system dependencies for WeasyPrint + Python
# RUN apt-get update && apt-get install -y --no-install-recommends \
#python3 \
#python3-pip \
#python3-dev \
#build-essential \
#    libffi-dev \
#    libxml2 \
#    libxml2-dev \
#    libxslt1-dev \
#    libcairo2 \
#    libcairo2-dev \
#    libpango-1.0-0 \
#    libpangocairo-1.0-0 \
#    libgdk-pixbuf2.0-0 \
#    libglib2.0-0 \
#    shared-mime-info \
#    libjpeg-turbo8 \
#    libpng-dev \
#    fonts-dejavu-core \
#    curl \
#    && apt-get clean \
#    && rm -rf /var/lib/apt/lists/*
#
## Upgrade pip
#RUN pip3 install --upgrade pip
#
## Install Python dependencies
#COPY requirements.txt .
#RUN pip3 install -r requirements.txt
#
## Copy project
#COPY . .
#
## Create a non-root user
#RUN useradd -ms /bin/bash django
#USER django
#
#EXPOSE 8000
#
#CMD ["gunicorn", "ecomm.wsgi:application", "--bind", "0.0.0.0:8000", "--workers=3"]


# Dockerfile (optimized for build speed & small image) - WeasyPrint dependencies added
FROM python:3.10-slim AS base
ENV PYTHONDONTWRITEBYTECODE=1 PYTHONUNBUFFERED=1

# Install system packages needed for many python wheels AND WeasyPrint runtime libs
# - build-essential, gcc: compile wheels if needed
# - libpq-dev: postgres client headers
# - curl, netcat: useful tools for entry scripts
# - libcairo2, libpango-1.0-0, libgdk-pixbuf2.0-0, libffi-dev, libglib2.0-0:
#    runtime libraries required by WeasyPrint (Cairo/Pango/GObject)
# - shared-mime-info: used by WeasyPrint for mime detection
# - pkg-config: helps building some bindings
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    gcc \
    libpq-dev \
    curl \
    netcat-openbsd \
    pkg-config \
    libcairo2 \
    libpango-1.0-0 \
    libpangocairo-1.0-0 \
    libgdk-pixbuf-2.0-0 \
    libffi-dev \
    libglib2.0-0 \
    shared-mime-info \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# install python deps separately to use cache efficiently
COPY requirements.txt .
RUN pip install --upgrade pip && pip install --no-cache-dir -r requirements.txt

# copy application
COPY . .

# create a non-root user (good practice)
RUN useradd -m appuser && chown -R appuser /app
USER appuser

ENV PORT=8000
EXPOSE 8000

# production cmd: gunicorn wsgi
CMD ["gunicorn", "ecomm.wsgi:application", "--bind", "0.0.0.0:8000", "--workers", "3"]
