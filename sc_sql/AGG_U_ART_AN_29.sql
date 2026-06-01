
ALTER TABLE [dbo].[U_ART_AN] ADD 
	art_codice varchar(10) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_ART_AN_art_codice] DEFAULT ('')
go

ALTER TABLE [dbo].[U_ART_AN] ADD 
	art_version varchar(5) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_ART_AN_art_version] DEFAULT ('')
go


