
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[PART_FOR] ADD 
	 PAR_FATTD numeric(17,3) NULL ,
	 PAR_FATTA numeric(17,3) NULL 
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[PART_FOR] WITH NOCHECK ADD 
	CONSTRAINT [DF_PART_FOR_PAR_FATTD] DEFAULT ('0') FOR [PAR_FATTD],
	CONSTRAINT [DF_PART_FOR_PAR_FATTA] DEFAULT ('0') FOR [PAR_FATTA]
go

UPDATE PART_FOR SET PAR_FATTD = 0
UPDATE PART_FOR SET PAR_FATTA = 0