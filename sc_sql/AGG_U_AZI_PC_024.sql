
/*
*** Variabili per le opzioni gestite nella scheda "Contabilità", sottoscheda "Controlli" dei parametri di sistema nel "form\menu_azi000.scx":
***		- Proponi pre-valorizzazione spese, in corrispondenza con i conti dedicati nei parametri
***		- Controllo di quadratura in corrispondenza dell' Imponibile e non del Totale documento
*/


ALTER TABLE [DBO].[U_AZI_PC] ADD 
	AZI_SPECTRLBF bit NOT NULL CONSTRAINT [DF_U_AZI_PC_AZI_SPECTRLBF] DEFAULT (0),
	AZI_IMPCTRLBF bit NOT NULL CONSTRAINT [DF_U_AZI_PC_AZI_IMPCTRLBF] DEFAULT (0)
GO