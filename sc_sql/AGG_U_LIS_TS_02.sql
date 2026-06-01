
/* 
*****************************************************************************************
COME INSERIMENTO CAMPO 'PREZZO MINIMO' IN TABELLA LISTINI PER CLIENTE/TIPO PROD./SPESSORE
*****************************************************************************************
*/

ALTER TABLE [dbo].[U_LIS_TS] ADD 
     LIS_PRZMIN numeric (17,6) NULL
go

ALTER TABLE [dbo].[U_LIS_TS] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_LIS_TS_LIS_PRZMIN] DEFAULT (0) FOR [LIS_PRZMIN]
go

UPDATE U_LIS_TS SET LIS_PRZMIN = 0
