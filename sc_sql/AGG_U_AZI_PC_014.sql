
/*
*** Variabile per il campo gestito nella scheda "Altro", sottoscheda "Documenti", sottoscheda "Tutti i documenti" dei parametri di sistema  nel "form\menu_azi000.scx":
***		- Controlla se usati più codici IVA nello stesso documento
*/

ALTER TABLE [DBO].[U_AZI_PC] ADD 
	AZI_CTRDETIVA bit NOT NULL  CONSTRAINT [DF_U_AZI_PC_AZI_CTRDETIVA] DEFAULT (0)
GO
