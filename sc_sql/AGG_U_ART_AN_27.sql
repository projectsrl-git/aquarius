
ALTER TABLE [dbo].[U_ART_AN] ADD 
	art_famtra varchar(03) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_ART_AN_art_famtra] DEFAULT ('')
go

