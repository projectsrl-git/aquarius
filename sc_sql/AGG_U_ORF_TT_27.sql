
/* 
**********************************************************************************************
INSERIMENTO CAMPO "TIPOLOGIA ORDINE" IN TESTATE ORDINI CLIENTI 
**********************************************************************************************
*/
ALTER TABLE [dbo].[U_ORF_TT] ADD 
	 ORD_ACURA [varchar] (3) COLLATE Latin1_General_CI_AS NULL,
	 ORD_ATTENZIONE [varchar] (70) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_ORF_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_ORF_TT_ORD_ACURA] DEFAULT ('') FOR [ORD_ACURA],
	CONSTRAINT [DF_U_ORF_TT_ORD_ATTENZIONE] DEFAULT ('') FOR [ORD_ATTENZIONE]
go

UPDATE U_ORF_TT SET ORD_ACURA = ''
UPDATE U_ORF_TT SET ORD_ATTENZIONE = ''

