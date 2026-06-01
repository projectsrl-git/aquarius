/*
*** Variabili per le opzioni gestite nella scheda "LIPE Xml" per la gestione della liquidazione iva trimestrale (LIPE) 
*** dei parametri di sistema  nel "form\menu_azi000.scx":
*/

ALTER TABLE [DBO].[U_AZI_PC] ADD 
	AZI_COD_FORNITURA varchar (10) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_AZI_PC_AZI_COD_FORNITURA] DEFAULT ('')
GO






