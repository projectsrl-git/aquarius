
/*
*** Variabile per l'opzione gestita nella scheda "Altro", sottoscheda "Documenti", sottoscheda "Ordini a fornitore" dei parametri di sistema nel "form\menu_azi000.scx":
***		- Impedisce l'inserimento degli ordini fornitori se in anagrafica i dati obbligatori non sono codificati correttamente

*** Variabili per le opzioni gestite nella scheda "Contabilità", sottoscheda "Controlli" dei parametri di sistema nel "form\menu_azi000.scx":
***		- Impedisce l'inserimento dei Clienti in Prima Nota se in anagrafica i dati obbligatori non sono codificati correttamente
***		- Impedisce l'inserimento dei Fornitori in Prima Nota se in anagrafica i dati obbligatori non sono codificati correttamente
*/

ALTER TABLE [DBO].[U_AZI_PC] ADD 
	AZI_CTRFOOR bit NOT NULL  CONSTRAINT [DF_U_AZI_PC_AZI_CTRFOOR] DEFAULT (0),
	AZI_CTRCLPN bit NOT NULL  CONSTRAINT [DF_U_AZI_PC_AZI_CTRCLPN] DEFAULT (0),
	AZI_CTRFOPN bit NOT NULL  CONSTRAINT [DF_U_AZI_PC_AZI_CTRFOPN] DEFAULT (0)
GO

-- SE AZIENDA PRODUZIONE DISPOSITIVI MEDICALI, SETTO IL VALORE PREDEFINITO
UPDATE U_AZI_PC SET AZI_CTRFOOR = CASE WHEN COALESCE((SELECT AZI_PRDISP FROM U_AZI_PA),0) = 1 THEN 1 ELSE 0 END
UPDATE U_AZI_PC SET AZI_CTRCLPN = CASE WHEN COALESCE((SELECT AZI_PRDISP FROM U_AZI_PA),0) = 1 THEN 1 ELSE 0 END
UPDATE U_AZI_PC SET AZI_CTRFOPN = CASE WHEN COALESCE((SELECT AZI_PRDISP FROM U_AZI_PA),0) = 1 THEN 1 ELSE 0 END