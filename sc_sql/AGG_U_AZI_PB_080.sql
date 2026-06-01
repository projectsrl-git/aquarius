
/*
*** Variabile per il campo gestito nella scheda "Impostazioni varie", sottoscheda "Impostazioni varie" dei parametri di sistema  nel "form\menu_azi000.scx":
***		- Ricerca parametri : abilita la ricerca all'interno della descrizione del parametro
*/

ALTER TABLE [DBO].[U_AZI_PB] ADD 
	AZI_RICPARDES BIT NOT NULL CONSTRAINT [DF_U_AZI_PB_AZI_RICPARDES] DEFAULT (0)
GO

-- SE AZIENDA PRODUZIONE DISPOSITIVI MEDICALI, SETTO A 1 (TRUE)
UPDATE U_AZI_PB SET AZI_RICPARDES = CASE WHEN COALESCE((SELECT AZI_PRDISP FROM U_AZI_PA),0) = 1 THEN 1 ELSE 0 END