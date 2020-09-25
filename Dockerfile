FROM python:3.8.6-slim
LABEL maintainer="fraph24@gmail.com"

WORKDIR /src
ADD poetry.lock pyproject.toml ./

RUN pip install poetry && \
    poetry install --no-root --no-dev

ADD . .

EXPOSE 8000

CMD ["/usr/local/bin/poetry", "run", "uvicorn", "gpapconv:app"]
