
if exists(select * from sys.columns where name = 'AZI_RATRIS' and object_id = object_id(N'[dbo].[U_AZI_PB]'))
BEGIN
	ALTER TABLE [dbo].[U_AZI_PB] DROP CONSTRAINT DF_U_AZI_PB_AZI_RATRIS
	ALTER TABLE [dbo].[U_AZI_PB] DROP COLUMN AZI_RATRIS
END

ALTER TABLE [DBO].[U_AZI_PB] ADD 
	AZI_RATRIS varchar(03) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_AZI_PB_AZI_RATRIS] DEFAULT ('')
GO

