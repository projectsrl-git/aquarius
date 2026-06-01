-- ********************************************************************************
-- Indicizzazione tabella U_ART_PR.DBF
-- ********************************************************************************

if exists (select name from dbo.sysindexes where name = 'U_ART_25')
   drop index U_ART_PR.U_ART_25
GO

CREATE INDEX [U_ART_25] ON [dbo].[U_ART_PR]([ART_CODSOC], [ART_CATMER], [ART_GRUEDI], [ART_EDITOR], [ART_COLLAN], [ART_ARGOME], [ART_CODPRI], [ART_AUTORE]) ON [PRIMARY]
GO



-- ********************************************************************************
-- Indicizzazione tabella U_CCO_TT.DBF
-- ********************************************************************************

if exists (select name from dbo.sysindexes where name = 'INDICE_11')
   drop index U_CCO_TT.INDICE_11
GO



-- ********************************************************************************
-- Indicizzazione tabella U_CNT_TT.DBF
-- ********************************************************************************


if exists (select name from dbo.sysindexes where name = 'INDICE_12')
   drop index U_CNT_TT.INDICE_12
GO
if exists (select name from dbo.sysindexes where name = 'INDICE_13')
   drop index U_CNT_TT.INDICE_13
GO