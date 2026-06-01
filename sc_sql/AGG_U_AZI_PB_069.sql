
/*
*** Variabile per il campo gestito nella scheda "Altro", sottoscheda "Documenti", sottoscheda "DDT clienti", dei parametri di sistema  nel "form\menu_azi000.scx":
***		- Magazzino elaborato per DDT conto visione
*/

ALTER TABLE [DBO].[U_AZI_PB] ADD 
	AZI_MAGVIS varchar(06) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_AZI_PB_AZI_MAGVIS] DEFAULT (0)
GO

-- SE AZIENDA PRODUZIONE DISPOSITIVI MEDICALI, SETTO A 'VIS'
UPDATE U_AZI_PB SET AZI_MAGVIS = CASE WHEN COALESCE((SELECT AZI_PRDISP FROM U_AZI_PA),0) = 1 THEN 'VIS' ELSE '' END

