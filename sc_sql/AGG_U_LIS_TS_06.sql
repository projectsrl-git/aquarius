/*********************************************************************************
NUOVI CAMPI "2° Sonto %" E "3° Sonto %" IN LISTINI PER CLIENTE-TIPO PROD.-SPESSORE
*********************************************************************************/

ALTER TABLE [dbo].[U_LIS_TS] ADD 
	LIS_SC2 numeric(5,2) NOT NULL CONSTRAINT [DF_U_LIS_TS_LIS_SC2] DEFAULT (0),
	LIS_SC3 numeric(5,2) NOT NULL CONSTRAINT [DF_U_LIS_TS_LIS_SC3] DEFAULT (0)
go
