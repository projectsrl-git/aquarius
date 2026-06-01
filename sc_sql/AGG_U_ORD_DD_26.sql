
/* 
***********************************************************************************************
INSERIMENTO CAMPO "SELEZIONE PER SPEDIZIONE" IN DETTAGLI ORDINI CLIENTI PER GESTIONE CHECK LIST
***********************************************************************************************
*/
ALTER TABLE [dbo].[U_ORD_DD] ADD 
	 ORD_SELSPED BIT NULL

go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_ORD_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_ORD_DD_ORD_SELSPED] DEFAULT (0) FOR [ORD_SELSPED]
go

UPDATE U_ORD_DD SET ORD_SELSPED = 0
