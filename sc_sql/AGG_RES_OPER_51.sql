/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[RES_OPER] ADD 
	RIST_OPZEMAIL bit NULL,
	RIST_OPZEMAIL2 numeric(2,0) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[RES_OPER] WITH NOCHECK ADD 
	CONSTRAINT [DF_RES_OPER_RIST_OPZEMAIL] DEFAULT (0) FOR [RIST_OPZEMAIL],
	CONSTRAINT [DF_RES_OPER_RIST_OPZEMAIL2] DEFAULT (0) FOR [RIST_OPZEMAIL2]
go

UPDATE RES_OPER SET RIST_OPZEMAIL = 0
UPDATE RES_OPER SET RIST_OPZEMAIL2 = 1
