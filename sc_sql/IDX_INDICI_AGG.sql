-- ********************************************************************************
-- Indicizzazione tabella U_AMM_CA.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_AMM_CA.INDICE_01
GO

CREATE INDEX [INDICE_01] ON [dbo].[U_AMM_CA]([AMM_CODAMM]) ON [PRIMARY]
GO
-- ********************************************************************************

-- ********************************************************************************
-- Indicizzazione tabella U_AMM_AT.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_AMM_AT.INDICE_01
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_02')
   drop index U_AMM_AT.INDICE_02
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_03')
   drop index U_AMM_AT.INDICE_03
GO

CREATE INDEX [INDICE_01] ON [dbo].[U_AMM_AT]([AMM_CODCES]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_02] ON [dbo].[U_AMM_AT]([AMM_CODCES], [AMM_CODCAT]) ON [PRIMARY]
GO
CREATE INDEX [INDICE_03] ON [dbo].[U_AMM_AT]([AMM_CODCES], [AMM_CODCAT], [AMM_CONCES], [AMM_DATUTI]) ON [PRIMARY]
GO
-- ********************************************************************************

-- ********************************************************************************
-- Indicizzazione tabella U_AMM_AD.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_AMM_AD.INDICE_01
GO

CREATE INDEX [INDICE_01] ON [dbo].[U_AMM_AD]([AMD_CODCES]) ON [PRIMARY]
GO
-- ********************************************************************************

-- ********************************************************************************
-- Indicizzazione tabella U_QUO_AM.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_QUO_AM.INDICE_01
GO

CREATE INDEX [INDICE_01] ON [dbo].[U_QUO_AM]([QUO_CODCES], [QUO_ANNRIF], [QUO_CODCAT]) ON [PRIMARY]
GO
-- ********************************************************************************
