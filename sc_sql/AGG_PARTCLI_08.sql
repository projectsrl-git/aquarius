
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[PART_CLI] ADD 
	 PAR_DTUSOL varchar(10) COLLATE Latin1_General_CI_AS NULL 
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[PART_CLI] WITH NOCHECK ADD 
	CONSTRAINT [DF_PART_CLI_PAR_DTUSOL] DEFAULT ('') FOR [PAR_DTUSOL]
go

UPDATE PART_CLI SET PAR_DTUSOL 	= ' ' 