/*
  Description:
    This query allows to convert notes from Geopaparazzi into a OSM XML
    file that can be imported into JOSM.
  Usage:
    $ sqlite3 geopaparazzi.gpap < gpap2osm.sql > geopaparazzi.osm
  Made by:
    Francesco Frassinelli - https://frafra.eu
*/
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
       '<osm version="0.6" generator="gpap-notes2osm 0.0.3">' ||
       group_concat(nodes, '') ||
       '</osm>'
  from body;
