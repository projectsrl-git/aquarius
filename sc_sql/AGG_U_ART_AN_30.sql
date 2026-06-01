
ALTER TABLE [dbo].[U_ART_AN] ADD 
	art_codmdb varchar(10) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_ART_AN_art_codmdb] DEFAULT ('')
go

