
/*
*** Variabile per i campi gestiti nella scheda "Top standard" dei parametri di sistema nel "form\menu_azi000.scx":
***		- Causale di Carico per sostituzione seriali
***		- Causale di Scarico per sostituzione seriali
*/

ALTER TABLE [DBO].[U_AZI_PB] ADD 
	AZI_CAUEXC varchar(3) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_AZI_PB_AZI_CAUEXC] DEFAULT (''),
	AZI_CAUEXS varchar(3) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_AZI_PB_AZI_CAUEXS] DEFAULT ('')
GO


-- SE AZIENDA PRODUZIONE DISPOSITIVI MEDICALI, SETTO I VALORI PREDEFINITI
UPDATE U_AZI_PB SET AZI_CAUEXC = CASE WHEN COALESCE((SELECT AZI_PRDISP FROM U_AZI_PA),0) = 1 THEN 'EX+' ELSE '' END
UPDATE U_AZI_PB SET AZI_CAUEXS = CASE WHEN COALESCE((SELECT AZI_PRDISP FROM U_AZI_PA),0) = 1 THEN 'EX-' ELSE '' END