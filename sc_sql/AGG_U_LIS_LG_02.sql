
/* 
**************************************************************************************************
ELIMINAZIONE VALUTA E TIPOLOGIA LISTINO CLIENTE IN TABELLA DI ABILITAZIONE LISTINI CLIENTE/ARTICOLO
**************************************************************************************************
*/
ALTER TABLE [dbo].[U_LIS_LG] DROP 
	CONSTRAINT [DF_U_LIS_LG_LIS_CODVAL]
go

ALTER TABLE [dbo].[U_LIS_LG] DROP COLUMN
	LIS_CODVAL
go

ALTER TABLE [dbo].[U_LIS_LG] DROP 
	CONSTRAINT [DF_U_LIS_LG_LIS_CODGLI]
go

ALTER TABLE [dbo].[U_LIS_LG] DROP COLUMN
	LIS_CODGLI
go
