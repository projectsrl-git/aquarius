/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[U_PED_PL] ADD 
	 MAG_CDAPRD varchar(16) COLLATE Latin1_General_CI_AS NULL,
	 MAG_DSAPRD varchar(50) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_PED_PL] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_PED_PL_MAG_CDAPRD] DEFAULT ('') FOR [MAG_CDAPRD],
	CONSTRAINT [DF_U_PED_PL_MAG_DSAPRD] DEFAULT ('') FOR [MAG_DSAPRD]
go

UPDATE U_PED_PL SET MAG_CDAPRD = SPACE(16)
UPDATE U_PED_PL SET MAG_DSAPRD = SPACE(50)
