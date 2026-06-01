--Visualizza il nome logico del DB e il nome fisico del DB
select name,filename from sysfiles

ALTER DATABASE Soprad_TEST
MODIFY FILE ( NAME = Soprad_Data, NEWNAME = Soprad_TEST_Data ) 

ALTER DATABASE Soprad_TEST
MODIFY FILE ( NAME = Soprad_Log, NEWNAME = Soprad_TEST_Log )



--effettua il clear del file di log
backup log Soprad_TEST with truncate_only
dbcc shrinkfile (Soprad_TEST_Log,0)
