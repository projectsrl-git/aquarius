
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_LIS_TS] ADD 
	 LIS_DTUVAR varchar(10) COLLATE Latin1_General_CI_AS NULL 
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_LIS_TS] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_LIS_TS_LIS_DTUVAR] DEFAULT ('') FOR [LIS_DTUVAR]
go

UPDATE U_LIS_TS SET LIS_DTUVAR 	= ' ' 

/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_LIS_TS] ADD 
	 LIS_COMME varchar(60) COLLATE Latin1_General_CI_AS NULL 
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_LIS_TS] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_LIS_TS_LIS_COMME] DEFAULT ('') FOR [LIS_COMME]
go

UPDATE U_LIS_TS SET LIS_COMME 	= ' ' 