
/*
*** Variabile per l'opzione gestita nella scheda "Altro", sottoscheda "Produzione", sottoscheda "Produzione dispositivi medicali" 
*** dei parametri di sistema  nel "form\menu_azi000.scx":
***		- Codice Linea prodotto finito vendibile
*/

ALTER TABLE [DBO].[U_AZI_PB] ADD 
	AZI_PDMLINPV varchar (3) COLLATE Latin1_General_CI_AS NULL 
GO

ALTER TABLE [DBO].[U_AZI_PB] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AZI_PB_AZI_PDMLINPV] DEFAULT ('') FOR [AZI_PDMLINPV]
GO

UPDATE U_AZI_PB SET AZI_PDMLINPV = ''
