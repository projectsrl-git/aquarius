/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[TIMESHT] ADD 
	ORAINI varchar(05) COLLATE Latin1_General_CI_AS NULL,
	ORAFIN varchar(05) COLLATE Latin1_General_CI_AS NULL,
	PAUSAORE numeric(10,0) NULL,
	PAUSAMIN numeric(10,0) NULL
go

-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[TIMESHT] WITH NOCHECK ADD 
	CONSTRAINT [DF_TIMESHT_ORAINI] DEFAULT ('') FOR [ORAINI],
	CONSTRAINT [DF_TIMESHT_ORAFIN] DEFAULT ('') FOR [ORAFIN],
	CONSTRAINT [DF_TIMESHT_PAUSAORE] DEFAULT (0) FOR [PAUSAORE],
	CONSTRAINT [DF_TIMESHT_PAUSAMIN] DEFAULT (0) FOR [PAUSAMIN]
go

UPDATE TIMESHT SET ORAINI = ''
UPDATE TIMESHT SET ORAFIN = ''
UPDATE TIMESHT SET PAUSAORE = 0
UPDATE TIMESHT SET PAUSAMIN = 0
