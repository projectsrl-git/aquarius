
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[SALDI_CLI] ADD 
	 par_estraipartita bit NULL


go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[SALDI_CLI] WITH NOCHECK ADD 
	CONSTRAINT [DF_SALDI_CLI_par_estraipartita] DEFAULT (0) FOR [par_estraipartita]

go

UPDATE SALDI_CLI SET par_estraipartita = 0
