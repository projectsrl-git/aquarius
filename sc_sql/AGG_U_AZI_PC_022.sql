
/*
*** Variabile per l'opzione gestita nella scheda "Altro", sottoscheda "Documenti", sottoscheda "Ordini a fornitore" dei parametri di sistema nel "form\menu_azi000.scx":
***		- Inserisce il codice articolo del fornitore come prefisso alla descrizione (e non come suffisso)
*/


ALTER TABLE [DBO].[U_AZI_PC] ADD 
	AZI_CDARTF_PREFIX bit NOT NULL CONSTRAINT [DF_U_AZI_PC_AZI_CDARTF_PREFIX] DEFAULT (0)
GO
