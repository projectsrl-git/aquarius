
/*
*** Variabile per l'opzione gestita nella scheda "Contabilità", sottoscheda "Impostazioni", sottoscheda "Impostazioni varie (2)", nel "form\menu_azi000.scx":
***		- Funzioni per il ricalcolo del numero di registrazione nel libro giornale fiscale con/senza aggiornamento del database
*/
     
ALTER TABLE [DBO].[U_AZI_PC] ADD 
	AZI_RICALCNR bit NOT NULL CONSTRAINT [DF_U_AZI_PC_AZI_RICALCNR] DEFAULT (0)
GO


ALTER TABLE [DBO].[U_AZI_PC] ADD 
	AZI_RICALCSTP bit NOT NULL CONSTRAINT [DF_U_AZI_PC_AZI_RICALCSTP] DEFAULT (0)
GO
