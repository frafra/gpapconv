-- name: gpap2geojson^
-- This query allows to convert notes from Geopaparazzi into a GeoJSON
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

-- name: gpap2osm^
-- This query allows to convert notes from Geopaparazzi into a OSM XML
  with body as (
       select '<node action="modify" ' ||
              'id="-' || _id || '" ' ||
              'lat="' || lat || '" ' ||
              'lon="' || lon || '">' || 
              group_concat('<tag ' ||
                'k="' || key || '" ' ||
                'v="' || (
                    case when val == 'true'  then 'yes'
                         when val == 'false' then 'no'
                         else val
                          end
                ) || '"/>', ''
              ) ||
              '</node>' as nodes
         from parsed
        group by _id
       ),
       parsed as (
       select _id, lat, lon,
              replace(json_extract(value, '$.key'),   '"', '&quot;') as key,
              replace(json_extract(value, '$.value'), '"', '&quot;') as val
         from notes,
              json_each(json_extract(notes.form, '$.forms[0].formitems'))
        where json_extract(value, '$.value') != ''
       )
select '<?xml version="1.0" encoding="UTF-8"?>' ||
       '<osm version="0.6" generator="gpap-conv">' ||
       group_concat(nodes, '') ||
       '</osm>'
  from body;
