/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[U_MAG_GG] ADD 
	 MAG_CLIENT varchar(50) COLLATE Latin1_General_CI_AS NULL,
	 MAG_NUMORD varchar(06) COLLATE Latin1_General_CI_AS NULL,
	 MAG_DATORD varchar(10) COLLATE Latin1_General_CI_AS NULL,
	 MAG_SYSORD varchar(10) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_MAG_GG] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_MAG_GG_MAG_CLIENT] DEFAULT ('') FOR [MAG_CLIENT],
	CONSTRAINT [DF_U_MAG_GG_MAG_NUMORD] DEFAULT ('') FOR [MAG_NUMORD],
	CONSTRAINT [DF_U_MAG_GG_MAG_DATORD] DEFAULT ('') FOR [MAG_DATORD],
	CONSTRAINT [DF_U_MAG_GG_MAG_SYSORD] DEFAULT ('') FOR [MAG_SYSORD]
go

UPDATE U_MAG_GG SET MAG_CLIENT = SPACE(50)
UPDATE U_MAG_GG SET MAG_NUMORD = SPACE(06)
UPDATE U_MAG_GG SET MAG_DATORD = SPACE(10)
UPDATE U_MAG_GG SET MAG_SYSORD = SPACE(10)



/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[U_MAG_CP] ADD 
	 MAG_CLIENT varchar(50) COLLATE Latin1_General_CI_AS NULL,
	 MAG_NUMORD varchar(06) COLLATE Latin1_General_CI_AS NULL,
	 MAG_DATORD varchar(10) COLLATE Latin1_General_CI_AS NULL,
	 MAG_SYSORD varchar(10) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_MAG_CP] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_MAG_CP_MAG_CLIENT] DEFAULT ('') FOR [MAG_CLIENT],
	CONSTRAINT [DF_U_MAG_CP_MAG_NUMORD] DEFAULT ('') FOR [MAG_NUMORD],
	CONSTRAINT [DF_U_MAG_CP_MAG_DATORD] DEFAULT ('') FOR [MAG_DATORD],
	CONSTRAINT [DF_U_MAG_CP_MAG_SYSORD] DEFAULT ('') FOR [MAG_SYSORD]
go

UPDATE U_MAG_CP SET MAG_CLIENT = SPACE(50)
UPDATE U_MAG_CP SET MAG_NUMORD = SPACE(06)
UPDATE U_MAG_CP SET MAG_DATORD = SPACE(10)
UPDATE U_MAG_CP SET MAG_SYSORD = SPACE(10)
