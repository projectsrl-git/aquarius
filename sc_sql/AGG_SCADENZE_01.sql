/* 
*********************************************************************
VARIAZIONE DIMENSIONI CAMPO SCADENZE.ORD_DESCRI DA 45 A 200 CARATTERI
*********************************************************************
*/
ALTER TABLE [dbo].[SCADENZE] ALTER COLUMN
	 ORD_DESCRI varchar(200) COLLATE Latin1_General_CI_AS NULL 
GO
