
-- CANCELLAZIONE RIGHE SUPERFLUE U_ORF_DL
DELETE FROM U_ORF_DL WHERE SUBSTRING(ORD_CODART,1,8) <> '01.003.G'

-- istruzioni per compattare il log del database (prima fa il backup del log)
backup log XILOPAN with truncate_only
dbcc shrinkfile (XILOPAN_Log,0)



-- istruzioni per compattare il database effettivo
DBCC SHRINKDATABASE (XILOPAN, NOTRUNCATE )

DBCC SHRINKDATABASE (XILOPAN, TRUNCATEONLY)


