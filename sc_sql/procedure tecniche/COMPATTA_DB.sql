-- SOLO PER SQL SEVER DAL 2000 AL 2005 : istruzioni per compattare il log del database (prima fa il backup del log)
backup log Quimari with truncate_only
dbcc shrinkfile (Quimari_Log,0)



-- istruzioni per compattare il database effettivo PER TUTTE LE VERIONI DI SWL SERVER
DBCC SHRINKDATABASE (Quimari, NOTRUNCATE )

DBCC SHRINKDATABASE (Quimari, TRUNCATEONLY)


