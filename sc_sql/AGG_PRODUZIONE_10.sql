/* 
*****************************************************************************************************************************
INSERIMENTO NUOVI CAMPI PER PROGRAMMA DI PRODUZIONE (MANUALE):
	- PRODUZIONE.NOSTPLOGO: Non stampa logo in etichette prod. finiti
	- PRODUZIONE.NOSTPCLIE: Non stampa cliente in etichette prod. finiti
*****************************************************************************************************************************
*/

ALTER TABLE [dbo].[PRODUZIONE] ADD 
	NOSTPLOGO bit NOT NULL CONSTRAINT [DF_PRODUZIONE_NOSTPLOGO] DEFAULT (0),
	NOSTPCLIE bit NOT NULL CONSTRAINT [DF_PRODUZIONE_NOSTPCLIE] DEFAULT (0)
GO
