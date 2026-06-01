
IF EXISTS (SELECT name FROM sys.indexes WHERE name = N'INDICE_08' and object_id = object_id(N'[dbo].[PART_CLI]'))
    DROP INDEX INDICE_08 ON PART_CLI;
GO

CREATE INDEX INDICE_08 ON PART_CLI (PAR_ANNO, PAR_NPART, PAR_NPROT)


GO


