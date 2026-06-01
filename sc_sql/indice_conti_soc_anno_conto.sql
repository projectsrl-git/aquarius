IF EXISTS (SELECT name FROM sys.indexes
            WHERE name = N'conti_soc_anno_conto')
    DROP INDEX conti_soc_anno_conto ON CONTI;
GO

CREATE INDEX conti_soc_anno_conto ON CONTI ( con_soc, con_anno, con_conto ) 



GO