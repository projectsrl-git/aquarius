
/*
*** Variabile per il campo gestito nella scheda "Altro", sottoscheda "Produzione", sottoscheda "Pannelli truciolari" dei parametri di sistema nel "form\menu_azi000.scx":
***		- Causale per Scarto massivo pannelli grezzi da levigare
*/


ALTER TABLE [DBO].[U_AZI_PB] ADD 
	AZI_CAUSCG varchar(3) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_AZI_PB_AZI_CAUSCG] DEFAULT ('')
GO

-- SE AZIENDA PRODUZIONE PANNELLI TRUCIOLARI, SETTO IL VALORE PREDEFINITO
UPDATE U_AZI_PB SET AZI_CAUSCG = CASE WHEN COALESCE((SELECT AZI_PRGPLET FROM U_AZI_PA),0) = 1 THEN 'SCG' ELSE '' END