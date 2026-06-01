
/*
*** VariabilI gestite nella scheda "F.E. xlm", di "form\menu_azi000.scx"  per la fatturazione elettronica
***		- Login URL
*/



ALTER TABLE [DBO].[U_AZI_PB] ADD 
	AZI_IBAN varchar(30) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_AZI_PB_AZI_IBAN] DEFAULT ('')

GO


ALTER TABLE [DBO].[U_AZI_PB] ADD 
	AZI_FORTRA varchar(10) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_AZI_PB_AZI_FORTRA] DEFAULT ('')

GO


