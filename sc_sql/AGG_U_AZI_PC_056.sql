/*
*** Variabile per l'opzione gestita nella scheda "Altro", sottoscheda "Documenti", sottoscheda "Ordini a fornitore" dei parametri di sistema  nel "form\menu_azi000.scx":
***		- Ignora Lead Time Standard e Lead Time Fornitore nell'inserimento riga ordine fornitore
*/
        
ALTER TABLE [DBO].[U_AZI_PC] ADD 
	AZI_NOLEADTIMEORF BIT NOT NULL CONSTRAINT [DF_U_AZI_PC_AZI_NOLEADTIMEORF] DEFAULT (0)
GO
