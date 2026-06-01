
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[PART_CLI] ADD 
	 PAR_NUMSOL numeric(6,0) NULL 
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[PART_CLI] WITH NOCHECK ADD 
	CONSTRAINT [DF_PART_CLI_PAR_NUMSOL] DEFAULT ('0') FOR [PAR_NUMSOL]
go

UPDATE PART_CLI SET PAR_NUMSOL = 0