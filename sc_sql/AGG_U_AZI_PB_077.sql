
/*
*** Variabile per il campo gestito nella scheda "Contabilità", sottoscheda "Impostazioni" dei parametri di sistema  nel "form\menu_azi000.scx":
***		- Mostra il messaggio di Gestione plafond iva acquisti solo al raggiungimento del limite
*/

ALTER TABLE [DBO].[U_AZI_PB] ADD 
	AZI_PLAFACQMSG BIT NOT NULL CONSTRAINT [DF_U_AZI_PB_AZI_PLAFACQMSG] DEFAULT (0)
GO

-- SE AZIENDA PRODUZIONE DISPOSITIVI MEDICALI, SETTO A 1 (TRUE)
UPDATE U_AZI_PB SET AZI_PLAFACQMSG = CASE WHEN COALESCE((SELECT AZI_PRDISP FROM U_AZI_PA),0) = 1 THEN 1 ELSE 0 END



/*
*** Variabile per il campo gestito nella scheda "Altro", sottoscheda "Documenti", sottoschede "Tutti i documenti" dei parametri di sistema  nel "form\menu_azi000.scx":
***		- Abilita per i documenti (FORNITORI) la gestione del codice iva prelevandolo dall'anagrafica fornitori
*/

ALTER TABLE [DBO].[U_AZI_PB] ADD 
	AZI_IVANAF BIT NOT NULL CONSTRAINT [DF_U_AZI_PB_AZI_IVANAF] DEFAULT (0)
GO

-- SE AZIENDA PRODUZIONE DISPOSITIVI MEDICALI, SETTO A 1 (TRUE)
UPDATE U_AZI_PB SET AZI_IVANAF = CASE WHEN COALESCE((SELECT AZI_PRDISP FROM U_AZI_PA),0) = 1 THEN 1 ELSE 0 END

