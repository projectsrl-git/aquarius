
/*
*** Variabile per l'opzione gestita nella scheda "Altro", sottoscheda "Documenti" , sottoscheda "Rda" dei parametri di sistema  nel "form\menu_azi000.scx":
***		- Web RDA: Link applicazione Web per approvazione RDA
*/

ALTER TABLE [DBO].[U_AZI_PB] ADD 
	AZI_WEBRDA  varchar(200) COLLATE Latin1_General_CI_AS NULL
GO

ALTER TABLE [DBO].[U_AZI_PB] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AZI_PB_AZI_WEBRDA] DEFAULT ('') FOR [AZI_WEBRDA]
GO

UPDATE U_AZI_PB SET AZI_WEBRDA = ''

