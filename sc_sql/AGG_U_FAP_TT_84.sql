
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_FAP_TT] ADD 
		ORD_ACURA varchar (2) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[U_FAP_TT] WITH NOCHECK ADD 
        CONSTRAINT [DF_U_FAP_TT_ORD_ACURA] DEFAULT ('') FOR [ORD_ACURA]
go



UPDATE U_FAP_TT SET ORD_ACURA	= ''

