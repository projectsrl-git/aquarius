
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_PRG_CL] ADD 
	 PRG_NUMPRG varchar(06) COLLATE Latin1_General_CI_AS NULL,
	 PRG_DATPRG varchar(10) COLLATE Latin1_General_CI_AS NULL,
	 PRG_PROGRE numeric(10) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_PRG_RA] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_PRG_CL_PRG_NUMPRG] DEFAULT ('') FOR [PRG_NUMPRG],
	CONSTRAINT [DF_U_PRG_CL_PRG_DATPRG] DEFAULT ('') FOR [PRG_DATPRG],
	CONSTRAINT [DF_U_PRG_CL_PRG_PROGRE] DEFAULT (0) FOR [PRG_PROGRE]
go

UPDATE U_PRG_CL SET PRG_NUMPRG = SPACE(06)
UPDATE U_PRG_CL SET PRG_DATPRG = SPACE(10)
UPDATE U_PRG_CL SET PRG_PROGRE = 0



