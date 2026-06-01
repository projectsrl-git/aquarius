
/*
*** Variabile per il campo gestito nella scheda "Menu" dei parametri di sistema nel "form\menu_azi000.scx":
***		- Abilita possibilità di Ricerca Programma integrata nella toolbar
*/

ALTER TABLE [DBO].[U_AZI_PB] ADD 
	AZI_RICPRG bit NOT NULL CONSTRAINT [DF_U_AZI_PB_AZI_RICPRG] DEFAULT (0)
GO

