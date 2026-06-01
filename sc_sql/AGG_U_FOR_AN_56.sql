/*    
***********************************************************************
INSERIMENTO CAMPO CODICE AGENTE IN TABELLA ANAGRAFICA FORNITORI
***********************************************************************
*/

ALTER TABLE [dbo].[U_FOR_AN] DROP CONSTRAINT
      DF_U_FOR_AN_for_porto
GO

ALTER TABLE [dbo].[U_FOR_AN] DROP COLUMN 
       for_porto
GO

ALTER TABLE [dbo].[U_FOR_AN] DROP CONSTRAINT
      DF_U_FOR_AN_for_tispe
GO

ALTER TABLE [dbo].[U_FOR_AN] DROP COLUMN 
       for_tispe
GO
 

ALTER TABLE [dbo].[U_FOR_AN] ADD 
	 for_porto varchar(3) COLLATE Latin1_General_CI_AS NULL,
	 for_tispe varchar(3) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_FOR_AN] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_FOR_AN_for_porto] DEFAULT ('') FOR [for_porto],
	CONSTRAINT [DF_U_FOR_AN_for_tispe] DEFAULT ('') FOR [for_tispe]

go

UPDATE U_FOR_AN SET for_porto = ''
UPDATE U_FOR_AN SET for_tispe = ''