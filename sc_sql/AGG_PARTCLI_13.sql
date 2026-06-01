
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[PART_CLI] ADD 
	 PAR_ALLE01 varchar(240) COLLATE Latin1_General_CI_AS NULL,
	 PAR_ALLE02 varchar(240) COLLATE Latin1_General_CI_AS NULL,
	 PAR_ALLE03 varchar(240) COLLATE Latin1_General_CI_AS NULL,
	 PAR_ALLE04 varchar(240) COLLATE Latin1_General_CI_AS NULL,
	 PAR_ALLE05 varchar(240) COLLATE Latin1_General_CI_AS NULL
 
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[PART_CLI] WITH NOCHECK ADD 
	CONSTRAINT [DF_PART_CLI_PAR_ALLE01] DEFAULT ('') FOR [PAR_ALLE01],
	CONSTRAINT [DF_PART_CLI_PAR_ALLE02] DEFAULT ('') FOR [PAR_ALLE02],
	CONSTRAINT [DF_PART_CLI_PAR_ALLE03] DEFAULT ('') FOR [PAR_ALLE03],
	CONSTRAINT [DF_PART_CLI_PAR_ALLE04] DEFAULT ('') FOR [PAR_ALLE04],
	CONSTRAINT [DF_PART_CLI_PAR_ALLE05] DEFAULT ('') FOR [PAR_ALLE05]
go

UPDATE PART_CLI SET PAR_ALLE01 	= ' '
UPDATE PART_CLI SET PAR_ALLE02 	= ' ' 
UPDATE PART_CLI SET PAR_ALLE03 	= ' ' 
UPDATE PART_CLI SET PAR_ALLE04 	= ' ' 
UPDATE PART_CLI SET PAR_ALLE05 	= ' '  