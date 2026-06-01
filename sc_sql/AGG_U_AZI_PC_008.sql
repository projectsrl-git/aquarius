
/*
*** Variabile per l'opzione gestita nella scheda "Altro", sottoscheda "Documenti", sottoscheda "Fatture" dei parametri di sistema nel "form\menu_azi000.scx":
***	Blocca la stampa e la ristampa delle fatture in caso di esenzione iva esaurita rispetto al plafond della lettera di intento
*/

ALTER TABLE [DBO].[U_AZI_PC] ADD 
	AZI_FATLCKINT bit NOT NULL  CONSTRAINT [DF_U_AZI_PC_AZI_FATLCKINT] DEFAULT (0)
GO
