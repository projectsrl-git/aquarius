/* 
REGOLA DI FATTURAZIONE In generazione fatture da fatturabile Servizi, crea commento del periodo di competenza (MM/AAAA)
*/
ALTER TABLE [dbo].[COMMESSA_TT] ADD 
	 	FlgRegola7 bit NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[COMMESSA_TT] WITH NOCHECK ADD 

	CONSTRAINT [DF_COMMESSA_TT_FlgRegola7] DEFAULT (0) FOR [FlgRegola7]
go

UPDATE COMMESSA_TT SET FlgRegola7 = 0



