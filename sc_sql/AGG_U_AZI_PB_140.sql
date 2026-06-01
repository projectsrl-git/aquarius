
/*
*** Variabili per l'opzione gestita nella scheda "Altro", sottoscheda "Produzione" dei parametri di sistema nel "form\menu_azi000.scx":
***	Produzione standard con gestione cablaggi
*/


ALTER TABLE [DBO].[U_AZI_PB] ADD 
	AZI_PRDCABLAGGI bit NOT NULL CONSTRAINT [DF_U_AZI_PB_AZI_PRDCABLAGGI] DEFAULT (0)
GO
