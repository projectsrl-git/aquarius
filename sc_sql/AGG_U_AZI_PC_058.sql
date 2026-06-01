/*
*** Variabile per l'opzione gestita nella scheda "Impostazioni varie", sottoscheda "Impostazioni varie", dei parametri di sistema  nel "form\menu_azi000.scx":
***		- Integrazione ambiente con sistema GIL
*/
        
ALTER TABLE [DBO].[U_AZI_PC] ADD 
	AZI_INTEGR_GIL BIT NOT NULL CONSTRAINT [DF_U_AZI_PC_AZI_INTEGR_GIL] DEFAULT (0)
GO
