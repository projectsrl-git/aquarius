
/*
*** Variabile per il campo gestito nella scheda "Altro", sottoscheda "Documenti", sottoscheda "Fatture clienti" dei parametri di sistema  nel "form\menu_azi000.scx":
***		- Assegna numerazione NUMFEL per clienti FVS anche senza fatturazione elettronica
*/

ALTER TABLE [DBO].[U_AZI_PB] ADD 
	AZI_NFELFVS BIT NOT NULL CONSTRAINT [DF_U_AZI_PB_AZI_NFELFVS] DEFAULT ('')
GO

-- SE AZIENDA PRODUZIONE DISPOSITIVI MEDICALI, SETTO A TRUE
UPDATE U_AZI_PB SET AZI_NFELFVS = CASE WHEN COALESCE((SELECT AZI_PRDISP FROM U_AZI_PA),0) = 1 THEN 1 ELSE 0 END

