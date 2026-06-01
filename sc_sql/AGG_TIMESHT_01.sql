
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[TIMESHT] ADD 
	 KMPER numeric(6,1) NULL,
	 KMVAL numeric(6,2) NULL,
	 RIMBSPEFOR numeric(6,2) NULL

go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[TIMESHT] WITH NOCHECK ADD 
	CONSTRAINT [DF_TIMESHT_KMPER] DEFAULT (0) FOR [KMPER],
	CONSTRAINT [DF_TIMESHT_KMVAL] DEFAULT (0) FOR [KMVAL],
	CONSTRAINT [DF_TIMESHT_RIMBSPEFOR] DEFAULT (0) FOR [RIMBSPEFOR]

go

UPDATE TIMESHT SET KMPER = 0
UPDATE TIMESHT SET KMVAL   = 0
UPDATE TIMESHT SET RIMBSPEFOR = 0