FROM eeacms/kgs:18.1.23
LABEL maintainer="EEA: IDM2 B-Team <eea-edw-b-team-alerts@googlegroups.com>"

# 2024 fixes
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 112695A0E562B32A \
 && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EF0F382A1A7B6500

RUN echo "deb [trusted=yes] http://archive.debian.org/debian stretch main\ndeb [trusted=yes] http://archive.debian.org/debian-security stretch/updates main" > /etc/apt/sources.list \
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


ENV WARMUP_BIN=/plone/instance/bin/warmup \
    WARMUP_INI=/plone/instance/warmup.ini \
    WARMUP_HEALTH_THRESHOLD=5

COPY buildout.cfg /plone/instance/
COPY warmup.ini /plone/instance/

# 2024 fixes - fix SSL certificate errors
RUN curl -Ok https://curl.se/ca/cacert.pem \
  && mv cacert.pem /etc/ssl/certs/ca-certificates.crt \
  && virtualenv venv \
  && HOME=/plone/ venv/bin/pip install setuptools==38.7.0 zc.buildout==2.13.7 wheel==0.37.1

RUN ./venv/bin/buildout
