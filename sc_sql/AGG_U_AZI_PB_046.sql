
/*
*** Variabile per il campo gestito nella scheda "Altro", sottoscheda "Documenti", sottoscheda "Tutti i documenti", dei parametri di sistema  nel "form\menu_azi000.scx":
***		- Calcolo del contributo polieco esclusivamente in base all'apposito spessore configurato in anagrafica articoli
*/

ALTER TABLE [DBO].[U_AZI_PB] ADD 
	AZI_OSPEPOL BIT NOT NULL DEFAULT (0)
GO
