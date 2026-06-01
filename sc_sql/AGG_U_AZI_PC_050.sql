
/*
*** Variabile per l'opzione "Attiva la gestione articoli retail" gestita nella scheda "Altro", sottoscheda "Produzione" dei parametri di sistema nel "form\menu_azi000.scx":
*/
     
ALTER TABLE [DBO].[U_AZI_PC] ADD 
	AZI_RETAIL bit NOT NULL CONSTRAINT [DF_U_AZI_PC_AZI_RETAIL] DEFAULT (0)
GO
