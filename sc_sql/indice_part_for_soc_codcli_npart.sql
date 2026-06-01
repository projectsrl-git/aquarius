IF EXISTS (SELECT name FROM sys.indexes
            WHERE name = N'PART_FOR_soc_codcli_npart')
    DROP INDEX PART_FOR_soc_codcli_npart ON PART_FOR;
GO

CREATE INDEX PART_FOR_soc_codcli_npart ON PART_FOR ( PAR_CODSOC, PAR_CODCLI, PAR_NPART ) 



GO