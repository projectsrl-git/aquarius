
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[U_PED_PL] ADD 
	 MAG_CODIMB varchar(03) COLLATE Latin1_General_CI_AS NULL,
	 MAG_DESIMB varchar(50) COLLATE Latin1_General_CI_AS NULL,
	 MAG_LARIMB numeric(7,2) NULL,
	 MAG_LUNIMB numeric(7,2) NULL,
	 MAG_ALTIMB numeric(7,2) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_PED_PL] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_PED_PL_MAG_CODIMB] DEFAULT ('') FOR [MAG_CODIMB],
	CONSTRAINT [DF_U_PED_PL_MAG_DESIMB] DEFAULT ('') FOR [MAG_DESIMB],
	CONSTRAINT [DF_U_PED_PL_MAG_LARIMB] DEFAULT (0) FOR [MAG_LARIMB],
	CONSTRAINT [DF_U_PED_PL_MAG_LUNIMB] DEFAULT (0) FOR [MAG_LUNIMB],
	CONSTRAINT [DF_U_PED_PL_MAG_ALTIMB] DEFAULT (0) FOR [MAG_ALTIMB]
go

UPDATE U_PED_PL SET MAG_CODIMB = SPACE(03)
UPDATE U_PED_PL SET MAG_DESIMB = SPACE(50)
UPDATE U_PED_PL SET MAG_LARIMB = 0
UPDATE U_PED_PL SET MAG_LUNIMB = 0
UPDATE U_PED_PL SET MAG_ALTIMB = 0
