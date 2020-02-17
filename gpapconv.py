#!/usr/bin/env python3

import hug

import output_format

import functools
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

def run_query_on_form(body, field_name, query_path):
    content = body[field_name]
    with tempfile.NamedTemporaryFile() as tf:
        tf.write(content)
        result = run_query_on_db(tf.name, query_path)
    return result

@hug.post('/gpap2osm', output=output_format.xml)
def gpap2osm(body):
    return run_query_on_form(body, 'file', 'queries/gpap2osm.sql')

@hug.post('/gpap2geojson', output=output_format.geojson)
def gpap2osm(body):
    return run_query_on_form(body, 'file', 'queries/gpap2geojson.sql')
