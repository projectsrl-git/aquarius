
/*
*** Variabile per il campo gestito nella scheda "Menu" dei parametri di sistema nel "form\menu_azi000.scx":
***		- Abilita possibilità di gestire o meno la GESTIONE DEI RATEI / RISCONTI
*/

ALTER TABLE [DBO].[U_AZI_PB] ADD 
	AZI_RAR bit NOT NULL CONSTRAINT [DF_U_AZI_PB_AZI_RAR] DEFAULT (0)
GO

