
/*
*** Variabile per il campo gestito nella scheda "Menu Piano dei Conti" dei parametri di sistema nel "form\menu_azi000.scx":
*** Abilits la gestione delle ricerche ad albero sul piano dei conti e per la trasformazione del conto contabile 
*** nel formato similcee
*/

ALTER TABLE [DBO].[U_AZI_PC] ADD 
	AZI_ALBEROCONTI bit NOT NULL CONSTRAINT [DF_U_AZI_PC_AZI_ALBEROCONTI] DEFAULT (0)
GO

ALTER TABLE [DBO].[U_AZI_PC] ADD 
	AZI_CONTOSIMILCEE bit NOT NULL CONSTRAINT [DF_U_AZI_PC_AZI_CONTOSIMILCEE] DEFAULT (0)
GO

ALTER TABLE [DBO].[U_AZI_PC] ADD 
	AZI_GRUPPICONTAB bit NOT NULL CONSTRAINT [DF_U_AZI_PC_AZI_GRUPPICONTAB] DEFAULT (0)
GO
