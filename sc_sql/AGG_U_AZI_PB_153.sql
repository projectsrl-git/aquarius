
/*
*** VariabilI gestite nella scheda "F.E. xlm", di "form\menu_azi000.scx"  per la fatturazione elettronica
***		- Link portale web per invio Fatture Elettroniche B2B 
***		- Link portale web per invio Fatture Elettroniche PA
***		- Link portale web per ricezione Fatture Elettroniche
*/



ALTER TABLE [DBO].[U_AZI_PB] ADD 
	AZI_FEVPRLNK varchar(254) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_AZI_PB_AZI_FEVPRLNK] DEFAULT (''),
	AZI_FEVPALNK varchar(254) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_AZI_PB_AZI_FEVPALNK] DEFAULT (''),
	AZI_FEALNK varchar(254) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_AZI_PB_AZI_FEALNK] DEFAULT ('')
GO
