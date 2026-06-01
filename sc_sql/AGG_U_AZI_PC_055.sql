/*
*** Variabile per l'opzione gestita nella scheda "Altro", sottoscheda "Documenti", sottoscheda "Tutti i documenti" dei parametri di sistema  nel "form\menu_azi000.scx":
***		- NON mostra alert spese Bolli/Incasso a prescindere dal tipo di Condizione di pagamento
*/
        
ALTER TABLE [DBO].[U_AZI_PC] ADD 
	AZI_NOALERTSPBOLL BIT NOT NULL CONSTRAINT [DF_U_AZI_PC_AZI_NOALERTSPBOLL] DEFAULT (0)
GO
