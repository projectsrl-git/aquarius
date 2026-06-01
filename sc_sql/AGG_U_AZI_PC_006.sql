
/*
*** Variabile per l'opzione gestita nella scheda "Contabilità", sottoscheda "Controlli" dei parametri di sistema nel "form\menu_azi000.scx":
***	Aggiorna prezzo su movimenti e giacenze in caso di variazione prezzo da controllo bolle/fatture
*/

ALTER TABLE [DBO].[U_AZI_PC] ADD 
	AZI_AMMCTRLBF bit NOT NULL CONSTRAINT [DF_U_AZI_PC_AZI_AMMCTRLBF] DEFAULT (0)
GO

-- SE AZIENDA PRODUZIONE DISPOSITIVI MEDICALI, SETTO IL VALORE PREDEFINITO
UPDATE U_AZI_PC SET AZI_AMMCTRLBF = CASE WHEN COALESCE((SELECT AZI_PRDISP FROM U_AZI_PA),0) = 1 THEN 1 ELSE 0 END