-- ********************************************************************************
-- Indicizzazione tabella U_BAN_AN.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'IDX_BAN_DESBAN')
   drop index U_BAN_AN.IDX_BAN_DESBAN
GO
 
CREATE INDEX [IDX_BAN_DESBAN] ON [dbo].[U_BAN_AN]([BAN_DESBAN]) ON [PRIMARY]
GO
 