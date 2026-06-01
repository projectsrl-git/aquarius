
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[CONTI] ADD 
	 CHI_DARE numeric(18,3)  NULL,
	 CHI_AVERE   numeric(18,3)  NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[CONTI] WITH NOCHECK ADD 
	CONSTRAINT [DF_CONTI_CHI_DARE] DEFAULT (0) FOR [CHI_DARE],
	CONSTRAINT [DF_CONTI_CHI_AVERE] DEFAULT (0) FOR [CHI_AVERE]

go

UPDATE CONTI SET CHI_DARE 	= 0
UPDATE CONTI SET CHI_AVERE 	= 0
