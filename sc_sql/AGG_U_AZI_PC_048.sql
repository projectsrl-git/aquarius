
/*
*** Variabile per l'opzione gestita nella scheda "Altro", sottoscheda "Documenti", sottoscheda "Carichi da fornitore", nel "form\menu_azi000.scx":
***		- Durante il carico da fornitore per conto lavoro, ricalcola il prezzo del prodotto caricato da Di.Ba.
*/
     
ALTER TABLE [DBO].[U_AZI_PC] ADD 
	AZI_RICBFOCLAV bit NOT NULL CONSTRAINT [DF_U_AZI_PC_AZI_RICBFOCLAV] DEFAULT (0)
GO
