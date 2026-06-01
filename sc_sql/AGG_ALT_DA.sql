
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_ALT_DA] ADD 
	 ALT_CODCLI varchar(10) COLLATE Latin1_General_CI_AS NULL,
	 ALT_DTASCA varchar(10) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_ALT_DA] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_ALT_DA_ALT_CODCLI] DEFAULT ('') FOR [ALT_CODCLI],
	CONSTRAINT [DF_U_ALT_DA_ALT_DTASCA] DEFAULT ('') FOR [ALT_DTASCA]
go

UPDATE U_ALT_DA SET ALT_CODCLI = SPACE(10)
UPDATE U_ALT_DA SET ALT_DTASCA = SPACE(10)
