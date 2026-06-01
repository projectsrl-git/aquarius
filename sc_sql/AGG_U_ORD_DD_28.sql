/* 
************************************************************************************************************
RETTIFICA NOME CAMPO TABELLA "SELEZIONE PER SPEDIZIONE" (CHECK LIST DI SPEDIZIONE PRODUZIONE DISP. MEDICALI)
************************************************************************************************************
*/
ALTER TABLE [dbo].[U_ORD_DD] DROP CONSTRAINT
	DF_U_ORD_DD_ORD_SELSPED
GO

ALTER TABLE [dbo].[U_ORD_DD] DROP COLUMN 
	ORD_SELSPED
GO


ALTER TABLE [dbo].[U_ORD_DD] ADD 
		ORS_SELSPED bit NOT NULL DEFAULT (0)
go
