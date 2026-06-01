/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[U_MAG_GG] ADD 
	 MAG_GMLIMP numeric(12,2) NULL,
	 MAG_GKGIMP numeric(12,2) NULL,
	 MAG_FLGMOD [bit] NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_MAG_GG] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_MAG_GG_MAG_GMLIMP] DEFAULT (0) FOR [MAG_GMLIMP],
	CONSTRAINT [DF_U_MAG_GG_MAG_GKGIMP] DEFAULT (0) FOR [MAG_GKGIMP],
	CONSTRAINT [DF_U_MAG_GG_MAG_FLGMOD] DEFAULT (0) FOR [MAG_FLGMOD]
go

UPDATE U_MAG_GG SET MAG_GMLIMP = 0
UPDATE U_MAG_GG SET MAG_GKGIMP = 0
UPDATE U_MAG_GG SET MAG_FLGMOD = 0


/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[U_MAG_CP] ADD 
	 MAG_GMLIMP numeric(12,2) NULL,
	 MAG_GKGIMP numeric(12,2) NULL,
	 MAG_FLGMOD [bit] NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_MAG_CP] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_MAG_CP_MAG_GMLIMP] DEFAULT (0) FOR [MAG_GMLIMP],
	CONSTRAINT [DF_U_MAG_CP_MAG_GKGIMP] DEFAULT (0) FOR [MAG_GKGIMP],
	CONSTRAINT [DF_U_MAG_CP_MAG_FLGMOD] DEFAULT (0) FOR [MAG_FLGMOD]
go

UPDATE U_MAG_CP SET MAG_GMLIMP = 0
UPDATE U_MAG_CP SET MAG_GKGIMP = 0
UPDATE U_MAG_CP SET MAG_FLGMOD = 0
