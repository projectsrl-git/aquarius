
/*
*** Variabile per il campo gestito nella scheda "Contabilità", sottoscheda "Partitari", dei parametri di sistema  nel "form\menu_azi000.scx":
***		- Attiva la possibilità di gestire il recupero crediti per singola scadenza (blocco per pagamenti e/o scadenziario)
*/

ALTER TABLE [DBO].[U_AZI_PB] ADD 
	azi_creivacee BIT NOT NULL CONSTRAINT [DF_U_AZI_PB_azi_creivacee] DEFAULT (0),
	azi_creivarev BIT NOT NULL CONSTRAINT [DF_U_AZI_PB_azi_creivarev] DEFAULT (0)
GO

-- SE AZIENDA PRODUZIONE DISPOSITIVI MEDICALI, SETTO A 1 (TRUE)
UPDATE U_AZI_PB SET azi_creivacee = 0
UPDATE U_AZI_PB SET azi_creivarev = 0