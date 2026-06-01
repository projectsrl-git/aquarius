/* 
*****************************************************************************************************************************
INSERIMENTO NUOVO CAMPO PER PROGRAMMA DI PRODUZIONE (MANUALE):
	- PRODUZIONE.NOSTPPROD: Non stampa Cod. prodotto e descrizione in etichette prod. finiti
*****************************************************************************************************************************
*/

ALTER TABLE [dbo].[PRODUZIONE] ADD 
	NOSTPPROD bit NOT NULL CONSTRAINT [DF_PRODUZIONE_NOSTPPROD] DEFAULT (0)
GO
