
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[TIMESHT] ADD 
	 SPESEGG numeric(10,2) NULL,
	 RIMBKM numeric(10,2) NULL,
	 IMPTRASFGG numeric(10,2) NULL

go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[TIMESHT] WITH NOCHECK ADD 
	CONSTRAINT [DF_TIMESHT_SPESEGG] DEFAULT (0) FOR [SPESEGG],
	CONSTRAINT [DF_TIMESHT_RIMBKM] DEFAULT (0) FOR [RIMBKM],
	CONSTRAINT [DF_TIMESHT_IMPTRASFGG] DEFAULT (0) FOR [IMPTRASFGG]

go

UPDATE TIMESHT SET SPESEGG = 0
UPDATE TIMESHT SET RIMBKM   = 0
UPDATE TIMESHT SET IMPTRASFGG = 0