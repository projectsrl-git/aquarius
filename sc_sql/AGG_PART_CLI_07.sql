/*    
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[PART_CLI] ADD 
	 SYS_PARTI varchar(10) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[PART_CLI] WITH NOCHECK ADD 
	CONSTRAINT [DF_PART_CLI_SYS_PARTI] DEFAULT ('') FOR [SYS_PARTI]

go

UPDATE PART_CLI SET SYS_PARTI = ''

