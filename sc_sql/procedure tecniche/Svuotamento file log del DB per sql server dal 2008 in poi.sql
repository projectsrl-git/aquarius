--Per SQL SERVER 2008 IN POI
ALTER DATABASE Quimari SET RECOVERY SIMPLE
-- Shrink the truncated log file 
DBCC SHRINKFILE (Quimari_log,1);
