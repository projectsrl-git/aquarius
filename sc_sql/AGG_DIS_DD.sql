
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_DIS_DD] ADD 
	 DIS_DATFO1 varchar(10) COLLATE Latin1_General_CI_AS NULL,
	 DIS_DATFO2 varchar(10) COLLATE Latin1_General_CI_AS NULL,
	 DIS_DATFO3 varchar(10) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_DIS_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_DIS_DD_DIS_DATFO1] DEFAULT ('') FOR [DIS_DATFO1],
	CONSTRAINT [DF_U_DIS_DD_DIS_DATFO2] DEFAULT ('') FOR [DIS_DATFO2],
	CONSTRAINT [DF_U_DIS_DD_DIS_DATFO3] DEFAULT ('') FOR [DIS_DATFO3]
go
