/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[COMMESSA_TT] ADD 
	 	FlgRegola4 bit NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[COMMESSA_TT] WITH NOCHECK ADD 

	CONSTRAINT [DF_COMMESSA_TT_FlgRegola4] DEFAULT (0) FOR [FlgRegola4]
go

UPDATE COMMESSA_TT SET FlgRegola4 = 0



