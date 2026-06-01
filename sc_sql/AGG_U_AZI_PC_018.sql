
/*
*** Variabile per il campo gestito nella scheda "Menu Piano dei Conti" dei parametri di sistema nel "form\menu_azi000.scx":
*** Abilita la gestione delle ricerche ad albero dei conti contabili su tutti gli altri form
*/


ALTER TABLE [DBO].[U_AZI_PC] ADD 
	AZI_RICALBERO bit NOT NULL CONSTRAINT [DF_U_AZI_PC_AZI_RICALBERO] DEFAULT (0)
GO
