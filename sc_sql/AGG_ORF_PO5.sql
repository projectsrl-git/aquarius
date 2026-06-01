
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_ORF_PO] ADD 
	 ORF_CODMIT varchar(10) COLLATE Latin1_General_CI_AS NULL,
	 ORF_RAGMIT varchar(10) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_ORF_PO] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_ORF_PO_ORF_CODMIT] DEFAULT ('') FOR [ORF_CODMIT],
	CONSTRAINT [DF_U_ORF_PO_ORF_RAGMIT] DEFAULT ('') FOR [ORF_RAGMIT]
go
