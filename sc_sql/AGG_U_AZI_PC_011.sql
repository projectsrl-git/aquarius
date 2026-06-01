
/*
*** Variabile per il campo gestito nella scheda "Altro", sottoscheda "Documenti", sottoschede "Ordini clienti" dei parametri di sistema nel "form\menu_azi000.scx":
***		- Obbligatorietà descrizione in lingua articoli
*/

ALTER TABLE [DBO].[U_AZI_PC] ADD 
	AZI_DSLAOBBL bit NOT NULL  CONSTRAINT [DF_U_AZI_PC_AZI_DSLAOBBL] DEFAULT (0)
GO
