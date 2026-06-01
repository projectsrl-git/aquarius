
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_ORF_PO] ADD 
	 ORF_CHIUSO [bit] NULL ,
	 ORF_QTAEV [numeric](11, 3) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_ORF_PO] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_ORF_PO_ORF_CHIUSO] DEFAULT (0) FOR [ORF_CHIUSO],
	CONSTRAINT [DF_U_ORF_PO_ORF_QTAEV] DEFAULT (0) FOR [ORF_QTAEV]
go
