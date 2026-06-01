/* 
*****************************************************************************
VARIAZIONE DIMENSIONI CAMPI TIPO GREZZO/NOBILITATO DA VARCHAR(1) A VARCHAR(2)
*****************************************************************************
*/
ALTER TABLE [dbo].[U_ART_AN] ALTER COLUMN
	 ART_TIPOG varchar(2) COLLATE Latin1_General_CI_AS
GO

ALTER TABLE [dbo].[U_ART_AN] ALTER COLUMN
	 ART_TIPON varchar(2) COLLATE Latin1_General_CI_AS
GO
