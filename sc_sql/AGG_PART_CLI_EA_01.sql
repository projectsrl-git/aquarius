/*    
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[PART_CLI_EA] ADD 
	 PAR_NPROT varchar(6) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[PART_CLI_EA] WITH NOCHECK ADD 
	CONSTRAINT [DF_PART_CLI_EA_PAR_NPROT] DEFAULT ('') FOR [PAR_NPROT]

go

UPDATE PART_CLI_EA SET PAR_NPROT = ''

