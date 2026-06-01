/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
  
ALTER TABLE [dbo].[LOG_NEW_MAG] ADD 
		AQM_MO_PREACQ numeric (19,6),
		AQM_GG_PRZCON numeric (19,6)
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[LOG_NEW_MAG] WITH NOCHECK ADD 
	CONSTRAINT [DF_LOG_NEW_MAG_AQM_MO_PREACQ] DEFAULT (0) FOR [AQM_MO_PREACQ],
	CONSTRAINT [DF_LOG_NEW_MAG_AQM_GG_PRZCON] DEFAULT (0) FOR [AQM_GG_PRZCON]
go

update LOG_NEW_MAG set AQM_MO_PREACQ = 0
update LOG_NEW_MAG set AQM_GG_PRZCON = 0
