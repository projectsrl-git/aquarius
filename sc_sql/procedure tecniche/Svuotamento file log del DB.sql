-- Da lanciare selezionando il DB "Prisma"
backup log Prisma_Log with truncate_only
dbcc shrinkfile (Prisma_Log,0)
