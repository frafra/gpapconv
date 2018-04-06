/*
  Description:
    This query allows to convert notes from Geopaparazzi into a GeoJSON
    file that can be imported into JOSM.
  Usage:
    $ sqlite3 geopaparazzi.gpap < gpap-notes2geojson.sql > geopaparazzi.geojson
  Made by:
    Francesco Frassinelli - https://frafra.eu
*/
  with osm as (
       select _id,
              json_group_object(
                json_extract(value, '$.key'),
                json_extract(value, '$.value')
              ) as dict
         from notes,
              json_each(json_extract(notes.form, '$.forms[0].formitems'))
        where json_extract(value, '$.value') != ''
        group by _id
       )
select json_object(
         'type', 'FeatureCollection',
         'features', json_group_array(json_object(
           'geometry', json_object(
                'type', 'Point',
                'coordinates', json_array(lon, lat)
           ),
           'type', 'Feature',
           'properties', json(osm.dict)
         ))
       )
  from notes
  join osm
    on notes._id = osm._id;
