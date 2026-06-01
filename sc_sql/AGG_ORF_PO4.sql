
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_ORF_PO] ADD 
	 ORF_QTASPE [numeric](11, 3) NULL,
	 ORF_QTADSP [numeric](11, 3) NULL
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_ORF_PO] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_ORF_PO_ORF_QTASPE] DEFAULT (0) FOR [ORF_QTASPE],
	CONSTRAINT [DF_U_ORF_PO_ORF_QTADSP] DEFAULT (0) FOR [ORF_QTADSP]
go
