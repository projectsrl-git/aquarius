
/* 
**********************************************************************************************
INSERIMENTO CAMPO "TIPOLOGIA ORDINE" IN TESTATE ORDINI CLIENTI 
**********************************************************************************************
*/
ALTER TABLE [dbo].[U_ORF_TT] ADD 
	 ORD_VARIE [varchar] (70) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_ORF_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_ORF_TT_ORD_VARIE] DEFAULT ('') FOR [ORD_VARIE]
go

UPDATE U_ORF_TT SET ORD_VARIE  = ''

