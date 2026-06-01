

ALTER TABLE [dbo].[U_FOR_AN] ADD
	FOR_IDLIST varchar(3) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_FOR_AN_FOR_IDLIST] DEFAULT ('')
GO



ALTER TABLE [dbo].[U_FOR_AN] ADD
	for_bswfor varchar(100) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_FOR_AN_for_bswfor] DEFAULT ('')
GO

