
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_AVA_SP] ADD 
	 AVA_MTLORI numeric(10) NULL,
	 AVA_MQRESI numeric(20,2) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_AVA_SP] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AVA_SP_AVA_MTLORI] DEFAULT (0) FOR [AVA_MTLORI],
	CONSTRAINT [DF_U_AVA_SP_AVA_MQRESI] DEFAULT (0) FOR [AVA_MQRESI]
go

UPDATE U_AVA_SP SET AVA_MTLORI = 0
UPDATE U_AVA_SP SET AVA_MQRESI = 0

	