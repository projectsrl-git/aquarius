
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_ORF_TT] ADD 
	 ORD_DESTIN varchar(04) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_ORF_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_ORF_TT_ORD_DESTIN] DEFAULT ('') FOR [ORD_DESTIN]
go

UPDATE U_ORF_TT SET ORD_DESTIN = SPACE(04)
