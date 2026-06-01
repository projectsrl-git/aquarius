
/* 
****************************************************************************
INSERIMENTO CAMPO PER NOTE DI TESTAT ORDINE VISUALIZZABILI IN STAMPA
****************************************************************************
*/
ALTER TABLE [dbo].[U_ORD_TT] ADD 
	 ORD_NOTEEV2 [text] COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_ORD_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_ORD_TT_ORD_NOTEEV2] DEFAULT ('') FOR [ORD_NOTEEV2]
go

UPDATE U_ORD_TT SET ORD_NOTEEV2 = ''

