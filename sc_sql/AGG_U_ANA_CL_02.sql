/*    
***********************************************************************
INSERIMENTO DATI LETTERA INTENTO IN ANAGRAFICA CLIENTI
***********************************************************************
*/

ALTER TABLE [dbo].[U_ANA_CL] ADD 
	 cli_ivasptras varchar(3) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_ANA_CL] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_ANA_CL_cli_ivasptras] DEFAULT ('') FOR [cli_ivasptras]
go

UPDATE U_ANA_CL SET cli_ivasptras = ''