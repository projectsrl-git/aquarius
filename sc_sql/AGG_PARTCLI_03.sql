
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[PART_CLI] ADD 
	 PAR_FATTD numeric(17,3) NULL ,
	 PAR_FATTA numeric(17,3) NULL 
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[PART_CLI] WITH NOCHECK ADD 
	CONSTRAINT [DF_PART_CLI_PAR_FATTD] DEFAULT ('0') FOR [PAR_FATTD],
	CONSTRAINT [DF_PART_CLI_PAR_FATTA] DEFAULT ('0') FOR [PAR_FATTA]
go

UPDATE PART_CLI SET PAR_FATTD = 0
UPDATE PART_CLI SET PAR_FATTA = 0