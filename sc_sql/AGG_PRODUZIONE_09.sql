/* 
*****************************************************************************************************************************
INSERIMENTO NUOVI CAMPI PER PROGRAMMA DI PRODUZIONE:
	- PRODUZIONE.COSTO: Costo totale Componente
*****************************************************************************************************************************
*/

if NOT exists(select * from sys.columns where name = 'COSTO' and object_id = object_id(N'[dbo].[PRODUZIONE]'))
BEGIN
	ALTER TABLE [dbo].[PRODUZIONE] ADD 
		[COSTO] [numeric] (19,6) NOT NULL CONSTRAINT [DF_PRODUZIONE_COSTO] DEFAULT (0)
END


