FROM fedora
LABEL maintainer="fraph24@gmail.com"

WORKDIR /src
ADD poetry.lock pyproject.toml .

RUN dnf -y install poetry sqlite && \
    dnf -y install gcc python3-devel && \
    poetry install --no-root --no-dev && \
    dnf -y remove gcc python3-devel && \
    dnf clean all

ADD . .

EXPOSE 8000

CMD ["/usr/bin/poetry", "run", "uwsgi", "--ini", "uwsgi.ini"]
