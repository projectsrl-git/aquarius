/* 
**********************************************************************
VARIAZIONE DIMENSIONI CAMPO CATEGORIA BENE DA VARCHAR(3) A VARCHAR(16)
**********************************************************************
*/
ALTER TABLE [dbo].[U_ART_PR] ALTER COLUMN
	 ART_CATBEN varchar(16) COLLATE Latin1_General_CI_AS
GO
