/*    
***********************************************************************
INSERIMENTO CAMPO RAGIONE SOCIALE RIDOTTA IN TABELLA ANAGRAFICA CLIENTI
***********************************************************************
*/

ALTER TABLE [dbo].[U_FOR_AN] ADD 
	 FOR_HOMPAG varchar(50) COLLATE Latin1_General_CI_AS NULL

go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_FOR_AN] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_FOR_AN_FOR_HOMPAG] DEFAULT ('') FOR [FOR_HOMPAG]
go

UPDATE U_FOR_AN SET FOR_HOMPAG = ''
