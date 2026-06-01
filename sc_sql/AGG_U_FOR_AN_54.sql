/*    
***********************************************************************
INSERIMENTO CAMPO CODICE AGENTE IN TABELLA ANAGRAFICA FORNITORI
***********************************************************************
*/

ALTER TABLE [dbo].[U_FOR_AN] ADD 
	 FOR_LISFOR varchar(10) COLLATE Latin1_General_CI_AS NULL

go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_FOR_AN] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_FOR_AN_FOR_LISFOR] DEFAULT ('') FOR [FOR_LISFOR]
go

UPDATE U_FOR_AN SET FOR_LISFOR = ''
