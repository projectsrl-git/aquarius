
/*
*** Variabile per il campo gestito nella scheda "Tutti i documentii" dei parametri di sistema nel "form\menu_azi000.scx":
*** Abilita la gestione del tasto per inserire le righe articoli in tutti i documenti
*/


ALTER TABLE [DBO].[U_AZI_PC] ADD 
	AZI_ISRTRIGHEDOC bit NOT NULL CONSTRAINT [DF_U_AZI_PC_AZI_ISRTRIGHEDOC] DEFAULT (0)
GO
