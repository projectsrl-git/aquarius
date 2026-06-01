/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_ASS_DD] ADD 
	 	 ASS_CODBAN varchar(13) COLLATE Latin1_General_CI_AS NULL,
	 	 ASS_SYSDOC varchar(10) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_ASS_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_ASS_DD_ASS_CODBAN] DEFAULT ('   ') FOR [ASS_CODBAN],
	CONSTRAINT [DF_U_ASS_DD_ASS_SYSDOC] DEFAULT ('   ') FOR [ASS_SYSDOC]
go

UPDATE U_ASS_DD SET ASS_SYSDOC 	= '     '
UPDATE U_ASS_DD SET ASS_CODBAN 	= '     '