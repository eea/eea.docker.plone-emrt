FROM eeacms/kgs:18.1.23
MAINTAINER "EEA: IDM2 B-Team"

ENV WARMUP_BIN=/plone/instance/bin/warmup \
    WARMUP_INI=/plone/instance/warmup.ini \
    WARMUP_HEALTH_THRESHOLD=5

COPY buildout.cfg /plone/instance/
COPY warmup.ini /plone/instance/

# 2024 fixes
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 112695A0E562B32A \
 && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EF0F382A1A7B6500

RUN echo "deb http://archive.debian.org/debian stretch main\ndeb http://archive.debian.org/debian-security stretch/updates main" > /etc/apt/sources.list \ 
 && apt-get update \
 && apt-key update \
 && apt-get install -y --no-install-recommends build-essential \
 libsasl2-dev python-dev libldap2-dev libssl-dev \
 vim libldap-common \
 && rm -vrf /var/lib/apt/lists/* \
 && apt-get purge -y --auto-remove build-essential \
 libsasl2-dev python-dev libssl-dev

# 2023 fixes
RUN apt-get update \
  && apt-get install -y --force-yes virtualenv \
  && rm -rf /var/lib/apt/lists/*

RUN virtualenv venv && HOME=/plone/ venv/bin/pip install zc.buildout==2.13.7 setuptools==38.7 wheel==0.37.1

RUN ./venv/bin/buildout
