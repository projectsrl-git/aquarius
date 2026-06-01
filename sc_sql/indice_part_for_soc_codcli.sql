IF EXISTS (SELECT name FROM sys.indexes
            WHERE name = N'part_for_soc_codcli')
    DROP INDEX part_for_soc_codcli ON PART_FOR;
GO

CREATE INDEX part_for_soc_codcli ON PART_FOR ( PAR_CODSOC, PAR_CODCLI ) 



GO