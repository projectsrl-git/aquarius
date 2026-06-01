/*
*** Variabili per le opzioni gestite nella scheda "Altro", sottoscheda "Produzione", sottoscheda "Produzione dispositivi medicali" 
*** dei parametri di sistema  nel "form\menu_azi000.scx":
***		- Codice Linea semilavorati di produzione esterna
*/

/*
*** Variabili per le opzioni gestite nella scheda "Altro", sottoscheda "Magazzino", sottoscheda "Magazzini per produz. dispositivi medicali" 
*** dei parametri di sistema  nel "form\menu_azi000.scx":
***		- Magazzino di destinazione per il materiale prelevato
***		- Magazzino di destinazione per il materiale versato
*/

ALTER TABLE [DBO].[U_AZI_PA] ADD 
	AZI_PDMLINSE varchar (3) COLLATE Latin1_General_CI_AS NULL 
GO

ALTER TABLE [DBO].[U_AZI_PA] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AZI_PA_AZI_PDMLINSE] DEFAULT ('') FOR [AZI_PDMLINSE]
GO

UPDATE U_AZI_PA SET AZI_PDMLINSE = ''