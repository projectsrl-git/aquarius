/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[U_FAP_TT] ADD 
	FLG_ACCONT BIT NULL,
	ACC_PRECED numeric(17,2) NULL,
	ACC_DAFATT numeric(17,2) NULL,
	ACC_ATTUAL numeric(17,2) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_FAP_TT] WITH NOCHECK ADD
	CONSTRAINT [DF_U_FAP_TT_FLG_ACCONT] DEFAULT (0) FOR [FLG_ACCONT],
	CONSTRAINT [DF_U_FAP_TT_ACC_PRECED] DEFAULT (0) FOR [ACC_PRECED],
	CONSTRAINT [DF_U_FAP_TT_ACC_DAFATT] DEFAULT (0) FOR [ACC_DAFATT],
	CONSTRAINT [DF_U_FAP_TT_ACC_ATTUAL] DEFAULT (0) FOR [ACC_ATTUAL]
go

UPDATE U_FAP_TT SET FLG_ACCONT = 0
UPDATE U_FAP_TT SET ACC_PRECED = 0
UPDATE U_FAP_TT SET ACC_DAFATT = 0
UPDATE U_FAP_TT SET ACC_ATTUAL = 0

