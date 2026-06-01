
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_FIN_DD] ADD 
	 	 FIN_NUMPRO varchar(10) COLLATE Latin1_General_CI_AS NULL,
	 	 FIN_SYSDOC varchar(10) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_FIN_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_FIN_DD_FIN_NUMPRO] DEFAULT ('   ') FOR [FIN_NUMPRO],
	CONSTRAINT [DF_U_FIN_DD_FIN_SYSDOC] DEFAULT ('   ') FOR [FIN_SYSDOC]
go

UPDATE U_FIN_DD SET FIN_NUMPRO 	= '     '
UPDATE U_FIN_DD SET FIN_SYSDOC 	= '     '
