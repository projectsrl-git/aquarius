/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_CON_DD] ADD 
	 	 CON_CGE     varchar(1) COLLATE Latin1_General_CI_AS NULL,
	 	 CON_CONTROP varchar(13) COLLATE Latin1_General_CI_AS NULL,
	 	 CON_DESCONP varchar(40) COLLATE Latin1_General_CI_AS NULL,
	 	 CON_NUMPRO varchar(10) COLLATE Latin1_General_CI_AS NULL,
	 	 CON_SYSDOC varchar(10) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_CON_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_CON_DD_CON_CGE] DEFAULT ('   ') FOR [CON_CGE],
	CONSTRAINT [DF_U_CON_DD_CON_CONTROP] DEFAULT ('   ') FOR [CON_CONTROP],
	CONSTRAINT [DF_U_CON_DD_CON_DESCONP] DEFAULT ('   ') FOR [CON_DESCONP],
	CONSTRAINT [DF_U_CON_DD_CON_NUMPRO] DEFAULT ('   ') FOR [CON_NUMPRO],
	CONSTRAINT [DF_U_CON_DD_CON_SYSDOC] DEFAULT ('   ') FOR [CON_SYSDOC]
go

UPDATE U_CON_DD SET CON_CGE 	= ' '
UPDATE U_CON_DD SET CON_NUMPRO 	= '     '
UPDATE U_CON_DD SET CON_SYSDOC 	= '     '
UPDATE U_CON_DD SET CON_CONTROP	= '     '
UPDATE U_CON_DD SET CON_DESCONP	= '     '