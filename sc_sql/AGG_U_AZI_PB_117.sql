
/*
*** Variabile per il campo gestito nella scheda "Altro", sottoscheda "Documenti", sottoscheda "Fatture clienti" dei parametri di sistema  nel "form\menu_azi000.scx":
***		- Articolo sconto cassa da proporre automaticamente in aggiornamento fattura
*/

ALTER TABLE [DBO].[U_AZI_PB] ADD 
	AZI_ASCASS varchar(16) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT ('')
GO

-- SE AZIENDA PRODUZIONE PANNELLI TRUCIOLARI, SETTO A 'SCC - SCONTO CASSA'
UPDATE U_AZI_PB SET AZI_ASCASS = CASE WHEN COALESCE((SELECT AZI_PRGPLET FROM U_AZI_PA),0) = 1 THEN 'SCC' ELSE '' END

