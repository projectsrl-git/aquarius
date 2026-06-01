
/*
*** Variabile per il campo gestito nella scheda "Altro", sottoscheda "Iva", sottoscheda "Impostazioni", dei parametri di sistema  nel "form\menu_azi000.scx":
***		- Gestisce il calcolo dell'acconto iva al 31/12/.... e lo stampa si nella liquidazione che nel riepilogo dei bollati va
*/

ALTER TABLE [DBO].[U_AZI_PB] ADD 
	AZI_ACCOIVA  BIT NOT NULL CONSTRAINT [DF_U_AZI_PB_AZI_ACCOIVA] DEFAULT (0)
GO


UPDATE U_AZI_PB SET AZI_ACCOIVA = 0