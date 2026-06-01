/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[CLIENTIC] ADD 
	NUMORC varchar (20) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_CLIENTIC_NUMORC] DEFAULT (''),
	DATORC varchar (10) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_CLIENTIC_DATORC] DEFAULT (''),
	IDSDI varchar (10) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_CLIENTIC_IDSDI] DEFAULT (''),
	RIFAMMFE varchar (150) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_CLIENTIC_RIFAMMFE] DEFAULT (''),
	EPEC varchar (200) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_CLIENTIC_EPEC] DEFAULT ('')
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
