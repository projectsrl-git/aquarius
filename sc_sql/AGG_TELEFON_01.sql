
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[TELEFON] ADD 
	[IDCONTATTOT] 	[varchar] (32) COLLATE Latin1_General_CI_AS NULL
GO



go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[TELEFON] WITH NOCHECK ADD 
	CONSTRAINT [DF_TELEFON_IDCONTATTOT] DEFAULT ('') FOR [IDCONTATTOT] 
go

UPDATE TELEFON SET IDCONTATTOT = ''



