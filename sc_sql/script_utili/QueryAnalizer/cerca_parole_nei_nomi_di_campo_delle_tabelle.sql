select tab.name,tab.object_id,col.* from sys.all_objects as tab

left outer join sys.all_columns as col on col..object_id = tab.object_id

where tab.type = 'U'

and col.name like '%SP%' AND col.SYSTEM_TYPE_ID = 108 AND col.PRECISION < 5

order by tab.name,col.column_id

