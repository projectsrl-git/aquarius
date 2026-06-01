
/*
*** Variabile per l'opzione gestita nella scheda "Altro", sottoscheda "Documenti", sottoscheda "Ordini a fornitore" dei parametri di sistema nel "form\menu_azi000.scx":
***		- Obbligatorietà del cambio giornaliero per gli ordini fornitori in valuta estera

*** Variabile per l'opzione gestita nella scheda "Altro", sottoscheda "Documenti", sottoscheda "Carichi da fornitore" dei parametri di sistema nel "form\menu_azi000.scx":
***		- Obbligatorietà del cambio giornaliero per i documenti di carico da fornitore in valuta estera
*/

ALTER TABLE [DBO].[U_AZI_PB] ADD 
	AZI_OBLGCHNGORF BIT NOT NULL CONSTRAINT [DF_U_AZI_PB_AZI_OBLGCHNGORF] DEFAULT (0),
	AZI_OBLGCHNGBFO BIT NOT NULL CONSTRAINT [DF_U_AZI_PB_AZI_OBLGCHNGBFO] DEFAULT (0)
GO

-- SE AZIENDA PRODUZIONE DISPOSITIVI MEDICALI, SETTO A TRUE
UPDATE U_AZI_PB SET AZI_OBLGCHNGORF = CASE WHEN COALESCE((SELECT AZI_PRDISP FROM U_AZI_PA),0) = 1 THEN 1 ELSE 0 END
UPDATE U_AZI_PB SET AZI_OBLGCHNGBFO = CASE WHEN COALESCE((SELECT AZI_PRDISP FROM U_AZI_PA),0) = 1 THEN 1 ELSE 0 END

