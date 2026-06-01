
/*
*** Variabile per il campo gestito nella scheda "Altro", sottoscheda "Produzione" dei parametri di sistema  nel "form\menu_azi000.scx":
***		- Considera il flag "Non valorizzare" per la rivalutazione dei costi
*/

ALTER TABLE [DBO].[U_AZI_PB] ADD 
	AZI_NONVAL BIT NOT NULL CONSTRAINT [DF_U_AZI_PB_AZI_NONVAL] DEFAULT ('')
GO

UPDATE U_AZI_PB SET AZI_NONVAL = 1