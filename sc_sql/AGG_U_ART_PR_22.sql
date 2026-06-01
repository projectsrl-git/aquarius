/* 
**********************************************************************
VARIAZIONE DIMENSIONI CAMPO ART_FORMUL DA VARCHAR(2) A VARCHAR(6)
**********************************************************************
*/
ALTER TABLE [dbo].[U_ART_PR] ALTER COLUMN
	 ART_FORMUL varchar(6) COLLATE Latin1_General_CI_AS
GO
