
/*
*** Variabile per l'opzione gestita nella scheda "Altro", sottoscheda "Documenti", sottoscheda "Ordini a fornitore" dei parametri di sistema nel "form\menu_azi000.scx":
***	Avvisa durante l'inserimento se il fornitore non ha ancora inviato l'accettazione delle condizioni generali di acquisto
*/

ALTER TABLE [DBO].[U_AZI_PC] ADD 
	AZI_ACGAALERT bit NOT NULL CONSTRAINT [DF_U_AZI_PC_AZI_ACGAALERT] DEFAULT (0)
GO

-- SE AZIENDA PRODUZIONE DISPOSITIVI MEDICALI, SETTO IL VALORE PREDEFINITO
UPDATE U_AZI_PC SET AZI_ACGAALERT = CASE WHEN COALESCE((SELECT AZI_PRDISP FROM U_AZI_PA),0) = 1 THEN 1 ELSE 0 END