# gpapconv

Geopaparazzi to OSM XML and GeoJSON converter

Demo: https://gpapconv.frafra.eu/

## Technologies

- [Python 3](https://www.python.org/)
  - [FastAPI](https://fastapi.tiangolo.com/)
  - [Uvicorn](https://www.uvicorn.org/)
- [sqlite](https://sqlite.org/)

## Setup

### Classic

```bash
python3 -m venv venv
source venv/bin/activate
pip install -e .
```

### Docker

```bash
docker compose up --build
```

## How to use

### Web interface

Open http://localhost:8000.

### Command line interface

From gpap to OSM XML:

```bash
curl -X POST -F "file=@geopaparazzi.gpap" http://localhost:8000/gpap2osm
```

From gpap to OSM GeoJSON:

```bash
curl -X POST -F "file=@geopaparazzi.gpap" http://localhost:8000/gpap2geojson
```
