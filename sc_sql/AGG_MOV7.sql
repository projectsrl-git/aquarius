
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_MAG_MO] ADD 
	 MOV_TIPTRA varchar(03) COLLATE Latin1_General_CI_AS NULL,
	 MOV_SYSGGG varchar(10) COLLATE Latin1_General_CI_AS NULL,
	 MOV_SYSGGS varchar(10) COLLATE Latin1_General_CI_AS NULL,
	 MOV_SYSDAG varchar(10) COLLATE Latin1_General_CI_AS NULL,
	 MOV_SYSDAS varchar(10) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_MAG_MO] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_MAG_MO_MOV_TIPTRA] DEFAULT ('') FOR [MOV_TIPTRA],
	CONSTRAINT [DF_U_MAG_MO_MOV_SYSGGG] DEFAULT ('') FOR [MOV_SYSGGG],
	CONSTRAINT [DF_U_MAG_MO_MOV_SYSGGS] DEFAULT ('') FOR [MOV_SYSGGS],
	CONSTRAINT [DF_U_MAG_MO_MOV_SYSDAG] DEFAULT ('') FOR [MOV_SYSDAG],
	CONSTRAINT [DF_U_MAG_MO_MOV_SYSDAS] DEFAULT ('') FOR [MOV_SYSDAS]
go

UPDATE U_MAG_MO SET MOV_TIPTRA = SPACE(03)
UPDATE U_MAG_MO SET MOV_SYSGGG = SPACE(10)
UPDATE U_MAG_MO SET MOV_SYSGGS = SPACE(10)
UPDATE U_MAG_MO SET MOV_SYSDAG = SPACE(10)
UPDATE U_MAG_MO SET MOV_SYSDAS = SPACE(10)


/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_MAG_CA] ADD 
	 MOV_TIPTRA varchar(03) COLLATE Latin1_General_CI_AS NULL,
	 MOV_SYSGGG varchar(10) COLLATE Latin1_General_CI_AS NULL,
	 MOV_SYSGGS varchar(10) COLLATE Latin1_General_CI_AS NULL,
	 MOV_SYSDAG varchar(10) COLLATE Latin1_General_CI_AS NULL,
	 MOV_SYSDAS varchar(10) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_MAG_CA] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_MAG_CA_MOV_TIPTRA] DEFAULT ('') FOR [MOV_TIPTRA]
	CONSTRAINT [DF_U_MAG_CA_MOV_SYSGGG] DEFAULT ('') FOR [MOV_SYSGGG],
	CONSTRAINT [DF_U_MAG_CA_MOV_SYSGGS] DEFAULT ('') FOR [MOV_SYSGGS],
	CONSTRAINT [DF_U_MAG_CA_MOV_SYSDAG] DEFAULT ('') FOR [MOV_SYSDAG],
	CONSTRAINT [DF_U_MAG_CA_MOV_SYSDAS] DEFAULT ('') FOR [MOV_SYSDAS]
go

UPDATE U_MAG_CA SET MOV_TIPTRA = SPACE(03)
UPDATE U_MAG_CA SET MOV_SYSGGG = SPACE(10)
UPDATE U_MAG_CA SET MOV_SYSGGS = SPACE(10)
UPDATE U_MAG_CA SET MOV_SYSDAG = SPACE(10)
UPDATE U_MAG_CA SET MOV_SYSDAS = SPACE(10)
