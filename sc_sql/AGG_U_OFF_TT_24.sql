
/* 
****************************************************************************
INSERIMENTO CAMPO PER NOTE DI TESTAT ORDINE VISUALIZZABILI IN STAMPA
****************************************************************************
*/
ALTER TABLE [dbo].[U_OFF_TT] ADD 
	 ORD_VARIE [text] COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_OFF_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_OFF_TT_ORD_VARIE] DEFAULT ('') FOR [ORD_VARIE]
go

UPDATE U_OFF_TT SET ORD_VARIE = ''

