
/*
*** Variabile per il campo gestito nella scheda "Altro", sottoscheda "Anagrafiche", sottoscheda "Anagrafica clienti" dei parametri di sistema  nel "form\menu_azi000.scx":
***		- Non visualizza negli help i clienti il cui codice compare in Anagrafica Fornitori come Codice cliente per compensazioni acquisti cee/reverse charge
*/

ALTER TABLE [DBO].[U_AZI_PB] ADD 
	AZI_NOCLICEE BIT NOT NULL CONSTRAINT [DF_U_AZI_PB_AZI_NOCLICEE] DEFAULT (0)
GO

-- SE AZIENDA PRODUZIONE DISPOSITIVI MEDICALI, SETTO A 1 (TRUE)
UPDATE U_AZI_PB SET AZI_NOCLICEE = CASE WHEN COALESCE((SELECT AZI_PRDISP FROM U_AZI_PA),0) = 1 THEN 1 ELSE 0 END