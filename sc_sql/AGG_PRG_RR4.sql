
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_PRG_RR] ADD 
	 MAN_MANDRI text COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_PRG_RR] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_PRG_RR_MAN_MANDRI] DEFAULT ('') FOR [MAN_MANDRI]
go

UPDATE U_PRG_RR SET MAN_MANDRI = SPACE(10)
