FROM python:3.11-alpine AS base
RUN --mount=type=bind,target=/pkg,rw \
    --mount=type=cache,target=/root/.cache/pip \
    pip install /pkg
EXPOSE 8000
CMD ["uvicorn", "--host", "0.0.0.0", "gpapconv:app"]
