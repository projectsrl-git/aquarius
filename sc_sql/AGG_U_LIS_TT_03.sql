
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_LIS_TT] ADD 
	 LIS_UMMAGA varchar(4) COLLATE Latin1_General_CI_AS NULL 
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_LIS_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_LIS_TT_LIS_UMMAGA] DEFAULT ('') FOR [LIS_UMMAGA]
go

UPDATE U_LIS_TT SET LIS_UMMAGA 	= '' 

