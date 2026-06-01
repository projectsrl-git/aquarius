
/*
*** Variabile per l'opzione gestita nella scheda "Contabilità", sottoscheda "Impostazioni" dei parametri di sistema nel "form\menu_azi000.scx":
***		- Abilita la modifica delle fatture fornitori richiamate dalla Ristampa Documenti (Tipo documento FAF)
*/


ALTER TABLE [DBO].[U_AZI_PC] ADD 
	AZI_FAFMOD bit NOT NULL CONSTRAINT [DF_U_AZI_PC_AZI_FAFMOD] DEFAULT (0)
GO


/*
*** Variabile per l'opzione gestita nella scheda "Contabilità", sottoscheda "Controlli" dei parametri di sistema nel "form\menu_azi000.scx":
***	Aggiorna prezzo su BFO in caso di variazione prezzo da controllo bolle/fatture
*/

ALTER TABLE [DBO].[U_AZI_PC] ADD 
	AZI_AMBCTRLBF bit NOT NULL CONSTRAINT [DF_U_AZI_PC_AZI_AMBCTRLBF] DEFAULT (0)
GO