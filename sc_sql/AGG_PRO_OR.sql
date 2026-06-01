
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_PRO_OR] ADD 
	 PRO_CDFORN varchar(10) COLLATE Latin1_General_CI_AS NULL,
	 PRO_DSFORN varchar(50) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_PRO_OR] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_PRO_OR_PRO_CDFORN] DEFAULT ('') FOR [PRO_CDFORN],
	CONSTRAINT [DF_U_PRO_OR_PRO_DSFORN] DEFAULT ('') FOR [PRO_DSFORN]
go
