#!/usr/bin/env python3


from fastapi import FastAPI, File, UploadFile
from starlette.responses import FileResponse, Response

import datetime
import functools
import json
import shutil
import sqlite3
import tempfile

@functools.lru_cache(maxsize=8)
def read_file(path):
    with open(path) as fp:
        return fp.read()

def run_query_on_db(db_path, query_path):
    with sqlite3.connect(db_path) as con:
        cur = con.cursor()
        query = read_file(query_path)
        result = cur.execute(query).fetchone()[0]
    return result

def run_query_on_form(file, query_path):
    with tempfile.NamedTemporaryFile() as tf:
        shutil.copyfileobj(file.file, tf)
        return run_query_on_db(tf.name, query_path)

def generate_filename(extension):
    return 'geopap-{}.{}'.format(datetime.date.today(), extension)

app = FastAPI()

@app.get("/")
async def index():
    return FileResponse('web/index.html')

@app.post("/gpap2osm")
async def gpap2osm(response: Response, file: UploadFile = File(...)):
    response.headers['Content-Disposition'] = generate_filename('xml')
    result = run_query_on_form(file, 'queries/gpap2osm.sql')
    return Response(result, media_type="application/xml")

@app.post("/gpap2geojson")
async def gpap2geojson(response: Response, file: UploadFile = File(...)):
    response.headers['Content-Disposition'] = generate_filename('geojson')
    result = run_query_on_form(file, 'queries/gpap2geojson.sql')
    return json.loads(result)
