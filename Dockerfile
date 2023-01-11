FROM eeacms/kgs:18.1.23
MAINTAINER "EEA: IDM2 B-Team"

ENV WARMUP_BIN=/plone/instance/bin/warmup \
    WARMUP_INI=/plone/instance/warmup.ini \
    WARMUP_HEALTH_THRESHOLD=5

COPY buildout.cfg /plone/instance/
COPY warmup.ini /plone/instance/

# 2023 fixes
RUN apt-get update \
  && apt-get install -y --force-yes virtualenv \
  && rm -rf /var/lib/apt/lists/*

RUN virtualenv venv && HOME=/plone/ venv/bin/pip install zc.buildout==2.13.7 setuptools==38.7

RUN ./venv/bin/buildout
