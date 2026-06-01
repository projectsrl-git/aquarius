
/*
*** Variabile per l'opzione gestita nella scheda "Altro", sottoscheda "Produzione", sottoscheda "Produzione dispositivi medicali" 
*** dei parametri di sistema  nel "form\menu_azi000.scx":
***		- All'aggiornamento di una Di.Ba. proponi ricalcolo costo standard su tutti i gruppi coinvolti
*/

ALTER TABLE [DBO].[U_AZI_PC] ADD 
	AZI_PDMRCS bit NOT NULL  CONSTRAINT [DF_U_AZI_PC_AZI_PDMRCS] DEFAULT (0)
GO
