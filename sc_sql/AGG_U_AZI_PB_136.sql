
/*
*** Variabile per l'opzione gestita nella scheda "Altro", sottoscheda "Produzione", sottoscheda "Anagrafiche", sottoscheda "Anagrafica articoli" 
*** dei parametri di sistema  nel "form\menu_azi000.scx":
***		- Abilita possibilità di inserimento codici articolo più lunghi di 16 caratteri (fino a 30 caratteri)
*/


ALTER TABLE [DBO].[U_AZI_PB] ADD 
	AZI_CDAR30 BIT NOT NULL CONSTRAINT [DF_U_AZI_PB_AZI_CDAR30] DEFAULT (0)
GO

