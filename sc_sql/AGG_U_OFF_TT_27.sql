
/* 
****************************************************************************
INSERIMENTO CAMPO DI TRACCIATURA UTILIZZO ORDINE PER CONTROLLO SU GESTIONALE
****************************************************************************
*/
ALTER TABLE [dbo].[U_OFF_TT] ADD 
	 ORD_LASTUSE varchar(200) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_OFF_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_OFF_TT_ORD_LASTUSE] DEFAULT ('') FOR [ORD_LASTUSE]
go

UPDATE U_OFF_TT SET ORD_LASTUSE = ''

