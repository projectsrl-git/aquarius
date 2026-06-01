
/*
*** Variabili per le opzioni gestite nella scheda "Altro", sottoscheda "Produzione", sottoscheda "Produzione dispositivi medicali" 
*** dei parametri di sistema  nel "form\menu_azi000.scx":
***		- Centro di costo standard per pianificazione acquisti
***		- All' apertura della pianificazione produzione apri quella CORRENTE
*/

ALTER TABLE [DBO].[U_AZI_PB] ADD 
	AZI_PDMCCOSTO varchar (13) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT (''),
	AZI_PDMOPZPC bit NOT NULL DEFAULT (0)
GO

UPDATE U_AZI_PB SET AZI_PDMCCOSTO = 'PROD'
UPDATE U_AZI_PB SET AZI_PDMOPZPC = 1
