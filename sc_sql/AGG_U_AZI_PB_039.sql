
/*
*** Variabili per le opzioni gestite nella scheda "Altro", sottoscheda "Produzione", sottoscheda "Produzione dispositivi medicali" 
*** dei parametri di sistema  nel "form\menu_azi000.scx":
***		- Causale di carico per versamenti Kit in spedizione
***		- Causale di scarico per versamenti Kit in spedizione
*/

ALTER TABLE [DBO].[U_AZI_PB] ADD 
	AZI_CAPPDMSPED varchar (3) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT (''),
	AZI_SCPPDMSPED varchar (3) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT ('')
GO
