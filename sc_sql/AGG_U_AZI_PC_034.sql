/*
*** Variabili per le opzioni gestite nella scheda "LIPE Xml" per la gestione della liquidazione iva trimestrale (LIPE) 
*** dei parametri di sistema  nel "form\menu_azi000.scx":
*/
--
ALTER TABLE [DBO].[U_AZI_PC] ADD 
	AZI_BNBASEURL varchar (200) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_AZI_PC_AZI_BNBASEURL] DEFAULT (''),
	AZI_BNUSER varchar (50) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_AZI_PC_AZI_BNUSER] DEFAULT (''),
	AZI_BNPASS varchar (50) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_AZI_PC_AZI_BNPASS] DEFAULT (''),
	AZI_BNPIVA varchar (20) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_AZI_PC_AZI_BNPIVA] DEFAULT ('')
GO