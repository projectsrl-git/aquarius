
if exists(select * from sys.columns where name = 'AZI_SGRU1' and object_id = object_id(N'[dbo].[U_AZI_PB]'))
BEGIN
	ALTER TABLE [dbo].[U_AZI_PB] DROP CONSTRAINT DF_U_AZI_PB_AZI_SGRU1
	ALTER TABLE [dbo].[U_AZI_PB] DROP COLUMN AZI_SGRU1
END

ALTER TABLE [DBO].[U_AZI_PB] ADD 
	AZI_SGRU1 varchar(010) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_AZI_PB_AZI_SGRU1] DEFAULT ('')
GO


if exists(select * from sys.columns where name = 'AZI_SGRU2' and object_id = object_id(N'[dbo].[U_AZI_PB]'))
BEGIN
	ALTER TABLE [dbo].[U_AZI_PB] DROP CONSTRAINT DF_U_AZI_PB_AZI_SGRU2
	ALTER TABLE [dbo].[U_AZI_PB] DROP COLUMN AZI_SGRU2
END

ALTER TABLE [DBO].[U_AZI_PB] ADD 
	AZI_SGRU2 varchar(010) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_AZI_PB_AZI_SGRU2] DEFAULT ('')
GO

if exists(select * from sys.columns where name = 'AZI_VALTC1' and object_id = object_id(N'[dbo].[U_AZI_PB]'))
BEGIN
	ALTER TABLE [dbo].[U_AZI_PB] DROP CONSTRAINT DF_U_AZI_PB_AZI_VALTC1
	ALTER TABLE [dbo].[U_AZI_PB] DROP COLUMN AZI_VALTC1
END

ALTER TABLE [DBO].[U_AZI_PB] ADD 
	AZI_VALTC1 varchar(01) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_AZI_PB_AZI_VALTC1] DEFAULT ('')
GO

if exists(select * from sys.columns where name = 'AZI_VALTC2' and object_id = object_id(N'[dbo].[U_AZI_PB]'))
BEGIN
	ALTER TABLE [dbo].[U_AZI_PB] DROP CONSTRAINT DF_U_AZI_PB_AZI_VALTC2
	ALTER TABLE [dbo].[U_AZI_PB] DROP COLUMN AZI_VALTC2
END

ALTER TABLE [DBO].[U_AZI_PB] ADD 
	AZI_VALTC2 varchar(01) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_AZI_PB_AZI_VALTC2] DEFAULT ('')
GO

