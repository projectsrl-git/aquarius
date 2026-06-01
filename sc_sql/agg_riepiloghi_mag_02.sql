
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_MAG_RI] ADD 
	[MAG_VAGIAC] [numeric] (20,3) NULL ,
	[MAG_VAVEND] [numeric] (20,3) NULL 
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_MAG_RI] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_MAG_RI_MAG_VAGIAC] DEFAULT (0) FOR [MAG_VAGIAC],
	CONSTRAINT [DF_U_MAG_RI_MAG_VAVEND] DEFAULT (0) FOR [MAG_VAVEND]
go

UPDATE U_MAG_RI SET MAG_VAGIAC = 0
UPDATE U_MAG_RI SET MAG_VAVEND = 0

/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_MAG_AR] ADD 
	[MAG_VAGIAC] [numeric] (20,3) NULL ,
	[MAG_VAVEND] [numeric] (20,3) NULL 
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_MAG_AR] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_MAG_AR_MAG_VAGIAC] DEFAULT (0) FOR [MAG_VAGIAC],
	CONSTRAINT [DF_U_MAG_AR_MAG_VAVEND] DEFAULT (0) FOR [MAG_VAVEND]
go

UPDATE U_MAG_AR SET MAG_VAGIAC = 0
UPDATE U_MAG_AR SET MAG_VAVEND = 0

/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_MAG_MA] ADD 
	[MAG_VAGIAC] [numeric] (20,3) NULL ,
	[MAG_VAVEND] [numeric] (20,3) NULL 
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_MAG_MA] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_MAG_MA_MAG_VAGIAC] DEFAULT (0) FOR [MAG_VAGIAC],
	CONSTRAINT [DF_U_MAG_MA_MAG_VAVEND] DEFAULT (0) FOR [MAG_VAVEND]
go

UPDATE U_MAG_MA SET MAG_VAGIAC = 0
UPDATE U_MAG_MA SET MAG_VAVEND = 0

/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_MAG_MF] ADD 
	[MAG_VAGIAC] [numeric] (20,3) NULL ,
	[MAG_VAVEND] [numeric] (20,3) NULL 
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_MAG_MF] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_MAG_MF_MAG_VAGIAC] DEFAULT (0) FOR [MAG_VAGIAC],
	CONSTRAINT [DF_U_MAG_MF_MAG_VAVEND] DEFAULT (0) FOR [MAG_VAVEND]
go

UPDATE U_MAG_MF SET MAG_VAGIAC = 0
UPDATE U_MAG_MF SET MAG_VAVEND = 0

/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_MAG_FO] ADD 
	[MAG_VAGIAC] [numeric] (20,3) NULL ,
	[MAG_VAVEND] [numeric] (20,3) NULL 
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_MAG_FO] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_MAG_FO_MAG_VAGIAC] DEFAULT (0) FOR [MAG_VAGIAC],
	CONSTRAINT [DF_U_MAG_FO_MAG_VAVEND] DEFAULT (0) FOR [MAG_VAVEND]
go

UPDATE U_MAG_FO SET MAG_VAGIAC = 0
UPDATE U_MAG_FO SET MAG_VAVEND = 0
