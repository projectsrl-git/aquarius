
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_MAG_MO] ADD 
	 MOV_CODOPE varchar(10) COLLATE Latin1_General_CI_AS NULL,
	 MOV_NOMOPE varchar(50) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_MAG_MO] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_MAG_MO_MOV_CODOPE] DEFAULT ('') FOR [MOV_CODOPE],
	CONSTRAINT [DF_U_MAG_MO_MOV_NOMOPE] DEFAULT ('') FOR [MOV_NOMOPE]
go

UPDATE U_MAG_MO SET MOV_CODOPE = SPACE(10)
UPDATE U_MAG_MO SET MOV_NOMOPE = SPACE(50)


/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_MAG_CA] ADD 
	 MOV_CODOPE varchar(10) COLLATE Latin1_General_CI_AS NULL,
	 MOV_NOMOPE varchar(50) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_MAG_CA] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_MAG_CA_MOV_CODOPE] DEFAULT ('') FOR [MOV_CODOPE],
	CONSTRAINT [DF_U_MAG_CA_MOV_NOMOPE] DEFAULT ('') FOR [MOV_NOMOPE]
go

UPDATE U_MAG_CA SET MOV_CODOPE = SPACE(10)
UPDATE U_MAG_CA SET MOV_NOMOPE = SPACE(50)
