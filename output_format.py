# Extending hug/output_format.py and adding custom headers

import hug

import datetime

@hug.format.content_type('text/xml; charset=utf-8')
def xml(content, request, response):
    """XML (eXtensible Markup Language)"""
    filename = 'geopap-{}.xml'.format(datetime.date.today())
    content_disposition = 'attachment; filename="{}"'.format(filename)
    response.set_header('Content-Disposition', content_disposition)
    return hug.output_format.html(content, request=request, response=response)

@hug.format.content_type('application/vnd.geo+json; charset=utf-8')
def geojson(content, request, response):
    """GeoJSON (Geographical JavaScript Object Notation)"""
    filename = 'geopap-{}.geojson'.format(datetime.date.today())
    content_disposition = 'attachment; filename="{}"'.format(filename)
    response.set_header('Content-Disposition', content_disposition)
    return hug.output_format.text(content, request=request, response=response)
