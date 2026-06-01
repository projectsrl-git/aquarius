/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_FOR_AN] ADD 
	 	 FOR_BANPRA varchar(10) COLLATE Latin1_General_CI_AS NULL,
	 	 FOR_CONACQ varchar(10) COLLATE Latin1_General_CI_AS NULL

go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_FOR_AN] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_FOR_AN_FOR_BANPRA] DEFAULT ('    ') FOR [FOR_BANPRA],
	CONSTRAINT [DF_U_FOR_AN_FOR_CONACQ] DEFAULT ('    ') FOR [FOR_CONACQ]
go

UPDATE U_FOR_AN SET FOR_BANPRA 	= SPACE(10)
UPDATE U_FOR_AN SET FOR_CONACQ 	= SPACE(10)
