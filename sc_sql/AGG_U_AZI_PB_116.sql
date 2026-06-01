
/*
*** Variabile per l'opzione gestita nella scheda "Altro", sottoscheda "Settaggi tecnici" dei parametri di sistema nel "form\menu_azi000.scx":
***		- Invio E-mail via SMTP utilizzando Microsoft Windows PowerShell (per default viene utilizzato VFP WinSock)
*/

ALTER TABLE [DBO].[U_AZI_PB] ADD 
	AZI_PSSENDMAIL BIT NOT NULL CONSTRAINT [DF_U_AZI_PB_AZI_PSSENDMAIL] DEFAULT (0)
GO
