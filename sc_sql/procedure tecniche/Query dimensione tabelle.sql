-- nome tabella, numero righe tabella, dimensione tabella in MB 

SELECT 
    t.NAME AS NOME_TABELLA,    
    p.rows AS NUMERO_RIGHE,
    round(CONVERT(float,SUM(a.total_pages)) * 8 / 1024,2)  AS MB_OCCUPATI   
FROM 
    sys.tables t
INNER JOIN      
    sys.indexes i ON t.OBJECT_ID = i.object_id
INNER JOIN 
    sys.partitions p ON i.object_id = p.OBJECT_ID AND i.index_id = p.index_id
INNER JOIN 
    sys.allocation_units a ON p.partition_id = a.container_id
LEFT OUTER JOIN 
    sys.schemas s ON t.schema_id = s.schema_id
WHERE 
    t.is_ms_shipped = 0
    AND i.OBJECT_ID > 255 
GROUP BY 
    t.Name, s.Name, p.Rows
ORDER BY 
    MB_OCCUPATI DESC, t.Name



-- dimensione LOG, dimensione DB, dimensione LOG+DB in MB
	SELECT 
      database_name = DB_NAME(database_id)
    , MB_log = CAST(SUM(CASE WHEN type_desc = 'LOG' THEN size END) * 8. / 1024 AS DECIMAL(8,2))
    , MB_database = CAST(SUM(CASE WHEN type_desc = 'ROWS' THEN size END) * 8. / 1024 AS DECIMAL(8,2))
    , MB_TOTALE = CAST(SUM(size) * 8. / 1024 AS DECIMAL(8,2))
FROM sys.master_files WITH(NOWAIT)
WHERE database_id = DB_ID() -- for current db 
GROUP BY database_id