
/*
*** Variabile gestita nella scheda "F.E. xlm", di "form\menu_azi000.scx"  per la fatturazione elettronica
***		- Usa la seguente directory fissa per i files XML forn.
*/

if exists(select * from sys.columns where name = 'AZI_FEDIRFISSA_FORN' and object_id = object_id(N'[dbo].[U_AZI_PB]'))
BEGIN
	ALTER TABLE [dbo].[U_AZI_PB] DROP CONSTRAINT DF_U_AZI_PB_AZI_FEDIRFISSA_FORN
	ALTER TABLE [dbo].[U_AZI_PB] DROP COLUMN AZI_FEDIRFISSA_FORN
END

ALTER TABLE [DBO].[U_AZI_PC] ADD 
	AZI_FEDIRFISSA_FORN varchar(254) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_AZI_PC_AZI_FEDIRFISSA_FORN] DEFAULT ('')
GO
