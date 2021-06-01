FROM python:3.9-alpine

LABEL maintainer="github@truebrain.nl"
LABEL org.opencontainers.image.author="Patric 'TrueBrain' Stout"
LABEL org.opencontainers.image.url=https://github.com/TrueBrain/actions-flake8
LABEL org.opencontainers.image.source=https://github.com/TrueBrain/actions-flake8
LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.title="Flake8 with GitHub Actions"
LABEL org.opencontainers.image.description="Flake8 with GitHub Actions -- including annotations for Pull Requests"

COPY LICENSE \
        README.md \
        entrypoint.sh \
        flake8-matcher.json \
        requirements.txt \
        /code/

RUN pip install -r /code/requirements.txt

ENTRYPOINT ["/code/entrypoint.sh"]
CMD []
