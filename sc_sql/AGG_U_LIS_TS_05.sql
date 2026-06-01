/***************************************************************
NUOVO CAMPO "Sonto %" IN LISTINI PER CLIENTE-TIPO PROD.-SPESSORE
***************************************************************/

ALTER TABLE [dbo].[U_LIS_TS] ADD 
	LIS_SC1 numeric(5,2) NOT NULL CONSTRAINT [DF_U_LIS_TS_LIS_SC1] DEFAULT (0)
go
