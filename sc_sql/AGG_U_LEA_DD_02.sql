
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_LEA_DD] ADD 
	 	 LEA_NUMPRO varchar(10) COLLATE Latin1_General_CI_AS NULL,
	 	 LEA_SYSDOC varchar(10) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_LEA_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_LEA_DD_LEA_NUMPRO] DEFAULT ('   ') FOR [LEA_NUMPRO],
	CONSTRAINT [DF_U_LEA_DD_LEA_SYSDOC] DEFAULT ('   ') FOR [LEA_SYSDOC]
go

UPDATE U_LEA_DD SET LEA_NUMPRO 	= '     '
UPDATE U_LEA_DD SET LEA_SYSDOC 	= '     '
