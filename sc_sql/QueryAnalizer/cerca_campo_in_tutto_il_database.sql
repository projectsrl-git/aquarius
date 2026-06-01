--       AND ( t.name LIKE '%U_ART_PR%'       -- filtro per nome specifico di una tabella 
--              OR c.name LIKE '%IVA%'     -- filtro per nome specifico di un campo

-- DETTAGLIATA PER CAMPO 
SELECT t.name AS tabella, 
       c.name AS colonna 
FROM   sys.tables t 
       INNER JOIN sys.columns c 
         ON t.object_id = c.object_id 
WHERE  [type] = 'U' 
       AND ( c.name LIKE '%IVA%'     -- filtro per nome specifico di un campo
)  
ORDER  BY t.name ASC, 
          c.name ASC  
