
if exists(select * from sys.columns where name = 'AZI_TOPINT' and object_id = object_id(N'[dbo].[U_AZI_PB]'))
BEGIN
	ALTER TABLE [dbo].[U_AZI_PB] DROP CONSTRAINT DF_U_AZI_PB_AZI_TOPINT
	ALTER TABLE [dbo].[U_AZI_PB] DROP COLUMN AZI_TOPINT
END

ALTER TABLE [DBO].[U_AZI_PB] ADD 
	AZI_TOPINT varchar(03) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_AZI_PB_AZI_TOPINT] DEFAULT ('')
GO

