/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[RES_OPER] ADD 
	FIRMA_MAIL text NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[RES_OPER] WITH NOCHECK ADD 
	CONSTRAINT [DF_RES_OPER_FIRMA_MAIL] DEFAULT '' FOR [FIRMA_MAIL]
go

UPDATE RES_OPER SET FIRMA_MAIL = ''
