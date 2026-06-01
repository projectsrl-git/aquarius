
/*
*** Variabile gestita nella scheda "F.E. xlm", di "form\menu_azi000.scx"  per la fatturazione elettronica
***		- Usa la seguente directory fissa per i files XML
*/



ALTER TABLE [DBO].[U_AZI_PB] ADD 
	AZI_FEDIRFISSA varchar(254) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_AZI_PB_AZI_FEDIRFISSA] DEFAULT ('')
GO
