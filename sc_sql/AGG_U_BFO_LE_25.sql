/* 
**********************************************************************
VARIAZIONE DIMENSIONI CAMPO LEG_NUMDOC DA VARCHAR(15) A VARCHAR(20)
**********************************************************************
*/
ALTER TABLE [dbo].[U_BFO_LE] ALTER COLUMN
	 LEG_NUMDOC varchar(20) COLLATE Latin1_General_CI_AS
GO
