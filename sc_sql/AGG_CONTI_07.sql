/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[CONTI] ADD 
	 CHI_MMCHI VARCHAR(2) COLLATE Latin1_General_CI_AS NULL,
	 CHI_TMOV VARCHAR(1) COLLATE Latin1_General_CI_AS NULL,
	 CHI_SALDO numeric(27,10)  NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[CONTI] WITH NOCHECK ADD 
	CONSTRAINT [DF_CONTI_CHI_MMCHI] DEFAULT ('') FOR [CHI_MMCHI],
	CONSTRAINT [DF_CONTI_CHI_TMOV] DEFAULT ('') FOR [CHI_TMOV],
	CONSTRAINT [DF_CONTI_CHI_SALDO] DEFAULT (0)  FOR [CHI_SALDO]
go

UPDATE CONTI SET CHI_MMCHI 	= SPACE(2)
UPDATE CONTI SET CHI_TMOV 	= SPACE(1)
UPDATE CONTI SET CHI_SALDO 	= 0



