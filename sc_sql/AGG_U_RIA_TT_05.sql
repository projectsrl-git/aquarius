
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_RIA_TT] ADD 
		ORD_CDC varchar (5) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[U_RIA_TT] WITH NOCHECK ADD 
        CONSTRAINT [DF_U_RIA_TT_ORD_CDC] DEFAULT ('') FOR [ORD_CDC]
go



UPDATE U_RIA_TT SET ORD_CDC 	= ''

