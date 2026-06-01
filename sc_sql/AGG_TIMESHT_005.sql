/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[TIMESHT] ADD 
	ORE_NOTT numeric(2,0) NULL,
	MIN_NOTT numeric(2,0) NULL
go

-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[TIMESHT] WITH NOCHECK ADD 
	CONSTRAINT [DF_TIMESHT_ORE_NOTT] DEFAULT (0) FOR [ORE_NOTT], 
	CONSTRAINT [DF_TIMESHT_MIN_NOTT] DEFAULT (0) FOR [MIN_NOTT]
go

UPDATE TIMESHT SET ORE_NOTT = 0
UPDATE TIMESHT SET MIN_NOTT = 0