
select tab.name as NOME_TABELLA, col.NAME AS NOME_CAMPO, tab.object_id,col.* from sys.all_objects as tab
left outer join sys.all_columns as col on col.object_id = tab.object_id
where tab.type = 'U' AND (col.name LIKE '%VALU%' OR col.name LIKE '%CODVAL%')
order by tab.name,col.column_id
