
/*
*** Variabile per il campo gestito nella scheda "Menu" dei parametri di sistema nel "form\menu_azi000.scx":
***		- Abilita possibilità di gestire o meno la LA CREAZIONE DEL NUOVO ESERCIZIO IN AUTOMATICO  AL PRIMO INGRESSO DI UN UTENTE A INIZIO ANNO
*/

ALTER TABLE [DBO].[U_AZI_PB] ADD 
	AZI_NEWYEAR bit NOT NULL CONSTRAINT [DF_U_AZI_PB_AZI_NEWYEAR] DEFAULT (0)
GO

