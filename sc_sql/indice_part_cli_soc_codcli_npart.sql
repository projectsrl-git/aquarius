IF EXISTS (SELECT name FROM sys.indexes
            WHERE name = N'PART_CLI_soc_codcli_npart')
    DROP INDEX PART_CLI_soc_codcli_npart ON PART_CLI;
GO

CREATE INDEX PART_CLI_soc_codcli_npart ON PART_CLI ( PAR_CODSOC, PAR_CODCLI, PAR_NPART ) 



GO