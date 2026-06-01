
/* 
**********************************************************************************************
INSERIMENTO CAMPO "TIPOLOGIA ORDINE" IN TESTATE ORDINI CLIENTI 
**********************************************************************************************
*/
ALTER TABLE [dbo].[U_ORD_TT] ADD 
	 ORD_TIPOLOGIA [varchar] (3) COLLATE Latin1_General_CI_AS NULL

go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_ORD_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_ORD_TT_ORD_TIPOLOGIA] DEFAULT ('') FOR [ORD_TIPOLOGIA]
go

UPDATE U_ORD_TT SET ORD_TIPOLOGIA = ''


