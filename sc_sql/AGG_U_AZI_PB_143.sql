
/*
*** Variabile per l'opzione gestita nella scheda "Altro", sottoscheda "Documenti", sottoscheda "Tutti i documenti" dei parametri di sistema nel "form\menu_azi000.scx":
***	Avvisa se al cliente/fornitore non è stata inviata l'informativa sulla privacy GDPR durante l'inserimento degli ordini
*/

ALTER TABLE [DBO].[U_AZI_PB] ADD 
	AZI_GDPRALERT bit NOT NULL CONSTRAINT [DF_U_AZI_PB_AZI_GDPRALERT] DEFAULT (0)
GO

-- SE AZIENDA PRODUZIONE DISPOSITIVI MEDICALI, SETTO IL VALORE PREDEFINITO
UPDATE U_AZI_PB SET AZI_GDPRALERT = CASE WHEN COALESCE((SELECT AZI_PRDISP FROM U_AZI_PA),0) = 1 THEN 1 ELSE 0 END