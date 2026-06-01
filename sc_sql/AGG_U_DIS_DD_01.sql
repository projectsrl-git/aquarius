
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_DIS_DD] ADD 
	 	 DIS_DSNOCQ varchar (50) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[U_DIS_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_DIS_DD_DIS_DSNOCQ] DEFAULT ('') FOR [DIS_DSNOCQ]

go


UPDATE U_DIS_DD SET DIS_DSNOCQ 	= ''
