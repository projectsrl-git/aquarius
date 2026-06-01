
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_BOL_TT] ADD 
		ORD_AAMMFA varchar (07) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[U_BOL_TT] WITH NOCHECK ADD 
        CONSTRAINT [DF_U_BOL_TT_ORD_AAMMFA] DEFAULT ('') FOR [ORD_AAMMFA]
go



UPDATE U_BOL_TT SET ORD_AAMMFA 	= ''


