
/*
*** Variabile per il campo gestito nella scheda "Altro", sottoscheda "Documenti", sottoscheda "Ordini clienti" dei parametri di sistema  nel "form\menu_azi000.scx":
***		- Consenti modifica righe ordine evase/in prod. tramite digitazione password
*/

ALTER TABLE [DBO].[U_AZI_PB] ADD 
	AZI_ORDMDD BIT NOT NULL CONSTRAINT [DF_U_AZI_PB_AZI_ORDMDD] DEFAULT (0)
GO

-- SE AZIENDA PRODUZIONE FILM PROTETTIVO CON PIANIFICAZIONE, SETTO A 1 (TRUE)
UPDATE U_AZI_PB SET AZI_ORDMDD = CASE WHEN COALESCE((SELECT AZI_PRDFPR FROM U_AZI_PB),0) = 1 THEN 1 ELSE 0 END
