
/*
*** Variabile per l'opzione gestita nella scheda "Altro", sottoscheda "Autocontrollo", sottoscheda "Fatture clienti" dei parametri di sistema nel "form\menu_azi000.scx":
***		- Nr. Giorni di riferimento per sfoltimento automatico tabella LOG_EMAIL
*/

ALTER TABLE [DBO].[U_AZI_PB] ADD 
	AZI_NGGLOGEML NUMERIC(4,0) NOT NULL CONSTRAINT [DF_U_AZI_PB_AZI_NGGLOGEML] DEFAULT (0)
GO
UPDATE U_AZI_PB SET AZI_NGGLOGEML = 730 -- per default tengo 2 anni di log


/*
*** Variabile per l'opzione gestita nella scheda "Altro", sottoscheda "Documenti", sottoscheda "Ddt clienti" dei parametri di sistema nel "form\menu_azi000.scx":
***		- Commento automatico Classe doganale anche in documenti con Nazione uguale al Codice nazione di default
*/

ALTER TABLE [DBO].[U_AZI_PB] ADD 
	AZI_DOGITA BIT NOT NULL CONSTRAINT [DF_U_AZI_PB_AZI_DOGITA] DEFAULT (0)
GO
-- SE AZIENDA PRODUZIONE PANNELLI TRUCIOLARI, SETTO I VALORI PREDEFINITI
UPDATE U_AZI_PB SET AZI_DOGITA = CASE WHEN COALESCE((SELECT AZI_PRGPLET FROM U_AZI_PA),0) = 1 THEN 1 ELSE 0 END