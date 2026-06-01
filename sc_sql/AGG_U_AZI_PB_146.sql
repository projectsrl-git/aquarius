
/*
*** Variabile per l'opzione gestita nella scheda "Contabilita'", sottoscheda "Impostazioni (1)", dei parametri di sistema nel "form\menu_azi000.scx":
***	Serve per abilitare o meno in prima nota l'import delle fatture elettroniche fornitori in formato XML
*/

ALTER TABLE [DBO].[U_AZI_PB] ADD 
	AZI_FATEXLM bit NOT NULL CONSTRAINT [DF_U_AZI_PB_AZI_FATEXLM] DEFAULT (0)
GO
