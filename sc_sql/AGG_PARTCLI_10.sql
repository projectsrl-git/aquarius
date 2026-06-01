
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[PART_CLI] ADD 
	[PAR_NOPART] [bit] NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[PART_CLI] WITH NOCHECK ADD 
	CONSTRAINT [DF_PART_CLI_PAR_NOPART] DEFAULT (0) FOR [PAR_NOPART]
go

UPDATE PART_CLI SET PAR_NOPART = 0