
/*
*** Variabile per il campo gestito nella scheda "Contabilità", sottoscheda "Partitari", dei parametri di sistema  nel "form\menu_azi000.scx":
***		- Attiva la possibilità di gestire il recupero crediti per singola scadenza (blocco per pagamenti e/o scadenziario)
*/

ALTER TABLE [DBO].[U_AZI_PB] ADD 
	AZI_LCKUNQSCAD BIT NOT NULL CONSTRAINT [DF_U_AZI_PB_AZI_LCKUNQSCAD] DEFAULT (0)
GO

-- SE AZIENDA PRODUZIONE DISPOSITIVI MEDICALI, SETTO A 1 (TRUE)
UPDATE U_AZI_PB SET AZI_LCKUNQSCAD = CASE WHEN COALESCE((SELECT AZI_PRDISP FROM U_AZI_PA),0) = 1 THEN 1 ELSE 0 END