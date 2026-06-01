
/*
*** Variabile per il campo gestito nella scheda "Altro", sottoscheda "Anagrafiche", sottoscheda "Anagrafica articoli" dei parametri di sistema  nel "form\menu_azi000.scx":
***		- Mostra Estensone descrizione in tendina di help anagrafica articoli
*/

        
ALTER TABLE [DBO].[U_AZI_PC] ADD 
	AZI_SHWEST BIT NOT NULL CONSTRAINT [DF_U_AZI_PC_AZI_SHWEST] DEFAULT (0)
GO
