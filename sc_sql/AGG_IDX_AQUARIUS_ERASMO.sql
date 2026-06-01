
-- ********************************************************************************
-- Indicizzazione tabella U_PDA_MO.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_PDA_MO.INDICE_01
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_PDA_MO.INDICE_02
GO


CREATE INDEX [INDICE_01] ON [dbo].[U_PDA_MO]([ID_UNIQUE]) ON [PRIMARY]
GO

CREATE INDEX [INDICE_02] ON [dbo].[U_PDA_MO]([MAG_CODSOC], [INV_CODMAG]) ON [PRIMARY]
GO
-- ********************************************************************************