
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[RES_OPER] ADD 
		 NUM_UTENTI numeric (10) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[RES_OPER] WITH NOCHECK ADD 
	CONSTRAINT [DF_RES_OPER_NUM_UTENTI] DEFAULT ('0')    FOR [NUM_UTENTI]
go

UPDATE RES_OPER SET NUM_UTENTI 	= 0 
