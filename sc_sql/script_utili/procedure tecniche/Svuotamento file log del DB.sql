-- Da lanciare selezionando il DB "Kompasso"
--backup log Kompasso with truncate_only
dbcc shrinkfile (Kompasso_Log,0)

