/*
*** Variabili per le opzioni gestite nella scheda "Top Standard"
*** dei parametri di sistema  nel "form\menu_azi000.scx":
***		- Top standard per identificare le fatture di acquisto
*/

ALTER TABLE [DBO].[U_AZI_PC] ADD 
	AZI_FATACQ varchar (10) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_AZI_PC_AZI_FATACQ] DEFAULT ('')
GO
