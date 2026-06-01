
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_ORF_PO] ADD 
	 ORF_DESTIN varchar(04) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_ORF_PO] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_ORF_PO_ORF_DESTIN] DEFAULT ('') FOR [ORF_DESTIN]
go
