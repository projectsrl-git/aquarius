
/* 
**********************************************************************************************
INSERIMENTO CAMPO "SELEZIONE PER SPEDIZIONE" IN TESTATE ORDINI CLIENTI PER GESTIONE CHECK LIST
**********************************************************************************************
*/
ALTER TABLE [dbo].[U_ORD_TT] ADD 
	 ORD_SELSPED BIT NULL

go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_ORD_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_ORD_TT_ORD_SELSPED] DEFAULT (0) FOR [ORD_SELSPED]
go

UPDATE U_ORD_TT SET ORD_SELSPED = 0


