
/*
*** Variabile per il campo gestito nella scheda "Consulenza" dei parametri di sistema nel "form\menu_azi000.scx":
*** Durante la creaione del fatturabile non effettua nessun ragruppamento per le commesse di servizi/prodotti
*/


ALTER TABLE [DBO].[U_AZI_PC] ADD 
	AZI_CONS_S_NORAG bit NOT NULL CONSTRAINT [DF_U_AZI_PC_AZI_CONS_S_NORAG] DEFAULT (0)
GO
