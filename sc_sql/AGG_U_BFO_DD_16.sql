/* 
**************************************************************************
INSERIRE NUOVO CAMPO IN DETTAGLI DOCUMENTI DI CARICO DA FORNITORE:
**************************************************************************
- ORD_MOVCTL: Identificativo univoco per legame con movimenti di scarico 
              magazzino esterno di Conto Lavoro
**************************************************************************
*/
ALTER TABLE [dbo].[U_BFO_DD] ADD 
	ORD_MOVCTL varchar (10) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[U_BFO_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_BFO_DD_ORD_MOVCTL] DEFAULT ('') FOR [ORD_MOVCTL]
go

UPDATE U_BFO_DD SET ORD_MOVCTL = ''

