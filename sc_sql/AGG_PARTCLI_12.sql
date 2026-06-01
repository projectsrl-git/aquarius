
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[PART_CLI] ADD 
	 PAR_DTNEWS varchar(10) COLLATE Latin1_General_CI_AS NULL 
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[PART_CLI] WITH NOCHECK ADD 
	CONSTRAINT [DF_PART_CLI_PAR_DTNEWS] DEFAULT ('') FOR [PAR_DTNEWS]
go

UPDATE PART_CLI SET PAR_DTNEWS 	= ' ' 