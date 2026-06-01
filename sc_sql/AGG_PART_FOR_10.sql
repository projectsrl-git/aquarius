/*    
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[PART_FOR] ADD 
	 SYS_PARTI varchar(10) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[PART_FOR] WITH NOCHECK ADD 
	CONSTRAINT [DF_PART_FOR_SYS_PARTI] DEFAULT ('') FOR [SYS_PARTI]

go

UPDATE PART_FOR SET SYS_PARTI = ''

