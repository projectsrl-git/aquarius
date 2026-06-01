/*
*** Variabili per le opzioni gestite nella scheda "Altro", sottoscheda "Web", sottoscheda "Gestit" 
*** dei parametri di sistema  nel "form\menu_azi000.scx":
***		- Nr. giorni max visibili in Interventi precedenti da concludere
*/

ALTER TABLE [DBO].[U_AZI_PC] ADD 
	AZI_GINRINT numeric(10,0) NOT NULL CONSTRAINT [DF_U_AZI_PC_AZI_AZI_GINRINT] DEFAULT (0)
GO
