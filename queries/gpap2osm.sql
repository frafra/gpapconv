/*
  Description:
    This query allows to convert notes from Geopaparazzi into a OSM XML
    file that can be imported into JOSM.
  Usage:
    $ sqlite3 geopaparazzi.gpap < gpap-notes2osm.sql > geopaparazzi.osm
  Made by:
    Francesco Frassinelli - https://frafra.eu
*/
  with body as (
       select '<node action="modify" ' ||
              'id="-' || _id || '" ' ||
              'lat="' || lat || '" ' ||
              'lon="' || lon || '">' || 
              group_concat('<tag ' ||
                'k="' || replace(json_extract(value, '$.key'),   '"', '&quot;') || '" ' ||
                'v="' || replace(json_extract(value, '$.value'), '"', '&quot;') || '"/>', ''
              ) ||
              '</node>' as nodes
         from notes,
              json_each(json_extract(notes.form, '$.forms[0].formitems'))
        where json_extract(value, '$.value') != ''
        group by _id
       )
select '<?xml version="1.0" encoding="UTF-8"?>' ||
       '<osm version="0.6" generator="gpap-notes2osm 0.0.3">' ||
       group_concat(nodes, '') ||
       '</osm>'
  from body;
