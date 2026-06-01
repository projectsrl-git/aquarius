
/*
*** VariabilI gestite nella scheda "F.E. xlm", di "form\menu_azi000.scx"  per la fatturazione elettronica
***		- Login URL
*/



ALTER TABLE [DBO].[U_AZI_PB] ADD 
	AZI_CONPAG varchar(05) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_AZI_PB_AZI_CONPAG] DEFAULT ('')

GO


ALTER TABLE [DBO].[U_AZI_PB] ADD 
	AZI_MODPAG varchar(05) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_AZI_PB_AZI_MODPAG] DEFAULT ('')

GO


