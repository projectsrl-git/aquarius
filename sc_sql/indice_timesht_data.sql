IF EXISTS (SELECT name FROM sys.indexes
            WHERE name = N'timesht_data')
    DROP INDEX timesht_data ON TIMESHT;
GO

CREATE INDEX timesht_data ON TIMESHT ( DATA ) 



GO


IF EXISTS (SELECT name FROM sys.indexes
            WHERE name = N'timesht_idcommessa')
    DROP INDEX timesht_idcommessa ON TIMESHT;
GO

CREATE INDEX timesht_idcommessa ON TIMESHT ( idcommessa ) 



GO