
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
-- INSERISCO IL CAMPO cli_scinco
ALTER TABLE [dbo].[U_LIS_TS] ADD 
     SELEZIONE varchar(10) COLLATE Latin1_General_CI_AS NULL
 
go


-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_LIS_TS] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_LIS_TS_SELEZIONE] DEFAULT ('') FOR [SELEZIONE]
go

UPDATE U_LIS_TS SET SELEZIONE = ''
