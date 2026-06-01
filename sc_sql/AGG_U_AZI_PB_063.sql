
/*
*** Variabile per il campo gestito nella scheda "Altro", sottoscheda "Documenti", sottoscheda "Fatture clienti" dei parametri di sistema  nel "form\menu_azi000.scx":
***		- Articolo spese di trasporto per creazione fatture da DDT e da Ordini, da riportare in dettagli
*/

ALTER TABLE [DBO].[U_AZI_PB] ADD 
	AZI_ARTTRA varchar(16) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT ('')
GO

-- SE AZIENDA PRODUZIONE DISPOSITIVI MEDICALI, SETTO A '.. - FREIGHT COSTS'
UPDATE U_AZI_PB SET AZI_ARTTRA = CASE WHEN COALESCE((SELECT AZI_PRDISP FROM U_AZI_PA),0) = 1 THEN '..' ELSE '' END

