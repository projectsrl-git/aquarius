
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[CONTI] ADD 
	 CON_FATTURA numeric(18,3)  NULL,
	 CON_NOTAC   numeric(18,3)  NULL,
	 PRE_FATTURA numeric(18,3)  NULL,
	 PRE_NOTAC   numeric(18,3)  NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[CONTI] WITH NOCHECK ADD 
	CONSTRAINT [DF_CONTI_CON_FATTURA] DEFAULT (0) FOR [CON_FATTURA],
	CONSTRAINT [DF_CONTI_CON_NOTAC] DEFAULT (0) FOR [CON_NOTAC],
	CONSTRAINT [DF_CONTI_PRE_FATTURA] DEFAULT (0) FOR [PRE_FATTURA],
	CONSTRAINT [DF_CONTI_PRE_NOTAC] DEFAULT (0) FOR [PRE_NOTAC]

go

UPDATE CONTI SET CON_FATTURA 	= 0
UPDATE CONTI SET CON_NOTAC 	= 0
UPDATE CONTI SET PRE_FATTURA 	= 0
UPDATE CONTI SET PRE_NOTAC 	= 0