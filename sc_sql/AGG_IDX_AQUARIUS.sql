-- ********************************************************************************
-- Indicizzazione tabella U_AST_AN.DBF
-- ********************************************************************************
if exists (select name from dbo.sysindexes where name = 'INDICE_01')
   drop index U_AST_AN.INDICE_01
GO
 
CREATE INDEX [INDICE_01] ON [dbo].[U_AST_AN]([AST_CODSOC], [AST_DATSCA], [AST_NUMSCA], [AST_NUMSCH], [AST_CODCLI], [AST_CODLOC], [AST_CODMAG], [AST_FILA_X], [AST_PIAN_X], [AST_UBIC_X]) ON [PRIMARY]
GO
 