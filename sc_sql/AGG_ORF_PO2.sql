
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_ORF_PO] ADD 
	 ORF_NUMDDT varchar(06) COLLATE Latin1_General_CI_AS NULL,
	 ORF_DATDDT varchar(10) COLLATE Latin1_General_CI_AS NULL,
	 ORF_QTADDT [numeric](11, 3) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_ORF_PO] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_ORF_PO_ORF_NUMDDT] DEFAULT ('') FOR [ORF_NUMDDT],
	CONSTRAINT [DF_U_ORF_PO_ORF_DATDDT] DEFAULT ('') FOR [ORF_DATDDT],
	CONSTRAINT [DF_U_ORF_PO_ORF_QTADDT] DEFAULT (0) FOR [ORF_QTADDT]
go

