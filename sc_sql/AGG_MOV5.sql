
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_MAG_MO] ADD 
	 MOV_TIPORI [numeric](1, 0) NULL ,
	 MOV_NUMORI varchar(06) COLLATE Latin1_General_CI_AS NULL,
	 MOV_DATORI varchar(10) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_MAG_MO] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_MAG_MO_MOV_TIPORI] DEFAULT (0) FOR [MOV_TIPORI],
	CONSTRAINT [DF_U_MAG_MO_MOV_NUMORI] DEFAULT ('') FOR [MOV_NUMORI],
	CONSTRAINT [DF_U_MAG_MO_MOV_DATORI] DEFAULT ('') FOR [MOV_DATORI]
go

UPDATE U_MAG_MO SET MOV_TIPORI = 0
UPDATE U_MAG_MO SET MOV_NUMORI = SPACE(06)
UPDATE U_MAG_MO SET MOV_DATORI = SPACE(10)


/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_MAG_CA] ADD 
	 MOV_TIPORI [numeric](1, 0) NULL ,
	 MOV_NUMORI varchar(06) COLLATE Latin1_General_CI_AS NULL,
	 MOV_DATORI varchar(10) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_MAG_CA] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_MAG_CA_MOV_TIPORI] DEFAULT (0) FOR [MOV_TIPORI],
	CONSTRAINT [DF_U_MAG_CA_MOV_NUMORI] DEFAULT ('') FOR [MOV_NUMORI],
	CONSTRAINT [DF_U_MAG_CA_MOV_DATORI] DEFAULT ('') FOR [MOV_DATORI]
go

UPDATE U_MAG_CA SET MOV_TIPORI = 0
UPDATE U_MAG_CA SET MOV_NUMORI = SPACE(06)
UPDATE U_MAG_CA SET MOV_DATORI = SPACE(10)

