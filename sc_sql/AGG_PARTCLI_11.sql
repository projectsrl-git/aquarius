/*    
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[PART_CLI] ADD 
	 PAR_STORIA text COLLATE Latin1_General_CI_AS NULL	
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[PART_CLI] WITH NOCHECK ADD 
	CONSTRAINT [DF_PART_CLI_PAR_STORIA] DEFAULT ('') FOR [PAR_STORIA]
go

UPDATE PART_CLI SET PAR_STORIA = ''


