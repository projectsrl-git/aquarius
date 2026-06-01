
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_MAG_GG] ADD 
	 MAG_LEGSYS varchar(10) COLLATE Latin1_General_CI_AS NULL
go

-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_MAG_GG] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_MAG_GG_MAG_LEGSYS] DEFAULT ('') FOR [MAG_LEGSYS]
go

UPDATE U_MAG_GG SET MAG_LEGSYS = SPACE(10)


