
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[SALDI_FOR] ADD 
	 par_estraipartita bit NULL


go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[SALDI_FOR] WITH NOCHECK ADD 
	CONSTRAINT [DF_SALDI_FOR_par_estraipartita] DEFAULT (0) FOR [par_estraipartita]

go

UPDATE SALDI_FOR SET par_estraipartita = 0
