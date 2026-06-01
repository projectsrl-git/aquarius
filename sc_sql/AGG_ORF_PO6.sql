/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_ORF_PO] ADD 
	 ORF_PAGAME varchar(03) COLLATE Latin1_General_CI_AS NULL,
	 ORF_CODACQ varchar(03) COLLATE Latin1_General_CI_AS NULL
go

-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_ORF_PO] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_ORF_PO_ORF_PAGAME] DEFAULT ('') FOR [ORF_PAGAME],
	CONSTRAINT [DF_U_ORF_PO_ORF_CODACQ] DEFAULT ('') FOR [ORF_CODACQ]
go

UPDATE U_ORF_PO SET ORF_PAGAME = SPACE(03)
UPDATE U_ORF_PO SET ORF_CODACQ = SPACE(03)

