
/*
*** Variabile per il campo gestito nella scheda "Contabilità", sottoscheda "Impostazioni" dei parametri di sistema  nel "form\menu_azi000.scx":
***		- In selezione partite fornitori da Prima Nota NON raggruppa per data scadenza
*/

ALTER TABLE [DBO].[U_AZI_PB] ADD 
	AZI_MENU_WIN8 BIT NOT NULL CONSTRAINT [DF_U_AZI_PB_AZI_MENU_WIN8] DEFAULT (0)
GO

-- SE AZIENDA PRODUZIONE DISPOSITIVI MEDICALI, SETTO A 1 (TRUE)
UPDATE U_AZI_PB SET AZI_MENU_WIN8 = 0