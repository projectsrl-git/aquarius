IF EXISTS (SELECT name FROM sys.indexes
            WHERE name = N'PART_CLI_soc_codcli')
    DROP INDEX PART_CLI_soc_codcli ON PART_CLI;
GO

CREATE INDEX PART_CLI_soc_codcli ON PART_CLI ( PAR_CODSOC, PAR_CODCLI ) 



GO