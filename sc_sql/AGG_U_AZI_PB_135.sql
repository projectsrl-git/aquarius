
/*
*** Variabile per l'opzione gestita nella scheda "Altro", sottoscheda "Produzione", sottoscheda "Film protettivi con pianificazione" 
*** dei parametri di sistema  nel "form\menu_azi000.scx":
***		- Capacità produttiva settimanale MQ massima prevista
*/


ALTER TABLE [DBO].[U_AZI_PB] ADD 
	AZI_MQMAXSET NUMERIC(10,0) NOT NULL CONSTRAINT [DF_U_AZI_PB_AZI_MQMAXSET] DEFAULT (0)
GO

