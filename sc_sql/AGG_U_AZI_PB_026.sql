
/*
*** Variabile per l'opzione gestita nella scheda "Altro", sottoscheda "Produzione", sottoscheda "Film protettivi con pianificazione" 
*** dei parametri di sistema  nel "form\menu_azi000.scx":
***		- Codice Linea prodotto finito vendibile
*/

ALTER TABLE [DBO].[U_AZI_PB] ADD 
	AZI_PFPLINPV varchar (3) COLLATE Latin1_General_CI_AS NULL 
GO

ALTER TABLE [DBO].[U_AZI_PB] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AZI_PB_AZI_PFPLINPV] DEFAULT ('') FOR [AZI_PFPLINPV]
GO

UPDATE U_AZI_PB SET AZI_PFPLINPV = ''
