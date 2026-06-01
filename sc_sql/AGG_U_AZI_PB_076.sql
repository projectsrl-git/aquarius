
/*
*** Variabile per il campo gestito nella scheda "Altro", sottoscheda "Anagrafiche", sottoschede "Anagrafica clienti"/"Anagrafica fornitori" dei parametri di sistema  nel "form\menu_azi000.scx":
***		- Controllo bloccante di mutua esclusività Cod. Fiscale / Partita Iva / Partita Iva CEE (anagr. clienti e fornitori)
*/

ALTER TABLE [DBO].[U_AZI_PB] ADD 
	AZI_PLAFACQF BIT NOT NULL CONSTRAINT [DF_U_AZI_PB_AZI_PLAFACQF] DEFAULT (0)
GO

-- SE AZIENDA PRODUZIONE DISPOSITIVI MEDICALI, SETTO A 1 (TRUE)
UPDATE U_AZI_PB SET AZI_PLAFACQF = 0
