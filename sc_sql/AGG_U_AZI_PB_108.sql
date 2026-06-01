
/*
*** Variabile per l' opzione gestita nella scheda "Contabilità", sottoscheda "Registrazioni automatiche" dei parametri di sistema  nel "form\menu_azi000.scx":
***		- Durante l'inserimento delle Fatture Fornitori CEE assegna automaticamente il TOP relativo
*/

ALTER TABLE [DBO].[U_AZI_PB] ADD 
	AZI_PNFFCE BIT NOT NULL CONSTRAINT [DF_U_AZI_PB_AZI_PNFFCE] DEFAULT (0)
GO

-- SE AZIENDA PRODUZIONE FILM PROTETTIVI CON PIANIFICAZIONE, SETTO A 1 (TRUE)
UPDATE U_AZI_PB SET AZI_PNFFCE = CASE WHEN COALESCE((SELECT azi_prdfpr FROM U_AZI_PA),0) = 1 THEN 1 ELSE 0 END
