IF EXISTS (SELECT name FROM sys.indexes
            WHERE name = N'budget_commessa_dp')
    DROP INDEX budget_commessa_dp ON COMMESSA_DP;
GO

CREATE INDEX budget_commessa_dp ON COMMESSA_DP ( IDCommessaD ) 

GO


IF EXISTS (SELECT name FROM sys.indexes
            WHERE name = N'budget_previsionale')
    DROP INDEX budget_previsionale ON BUDGET_PREV;
GO

CREATE INDEX budget_previsionale ON BUDGET_PREV ( IDCommessa_dp ) 

GO


IF EXISTS (SELECT name FROM sys.indexes
            WHERE name = N'budget_commessa_dc')
    DROP INDEX budget_commessa_dc ON COMMESSA_DC;
GO

CREATE INDEX budget_commessa_dc ON COMMESSA_DP ( IDCommessaD ) 

GO



IF EXISTS (SELECT name FROM sys.indexes
            WHERE name = N'budget_consolidato')
    DROP INDEX budget_consolidato ON BUDGET_CONS;
GO

CREATE INDEX budget_consolidato ON BUDGET_CONS ( IDCommessa_dc ) 

GO