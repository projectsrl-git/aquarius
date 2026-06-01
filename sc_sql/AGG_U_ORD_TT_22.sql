
/* 
****************************************************************************
INSERIMENTO CAMPO DI TRACCIATURA UTILIZZO ORDINE PER CONTROLLO SU GESTIONALE
****************************************************************************
*/
ALTER TABLE [dbo].[U_ORD_TT] ADD 
	 ORD_NOTEEVA [text] COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_ORD_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_ORD_TT_ORD_NOTEEVA] DEFAULT ('') FOR [ORD_NOTEEVA]
go

UPDATE U_ORD_TT SET ORD_NOTEEVA = ''

