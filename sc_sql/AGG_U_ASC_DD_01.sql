/*    
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[U_ASC_DD] ADD 
	 SYS_PARTI varchar(10) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_ASC_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_ASC_DD_SYS_PARTI] DEFAULT ('') FOR [SYS_PARTI]

go

UPDATE U_ASC_DD SET SYS_PARTI = ''

