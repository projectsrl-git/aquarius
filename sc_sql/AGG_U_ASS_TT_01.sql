/* 
**************************************************************
COME CANCELLARE UN CAMPO IN UNA TABELLA
**************************************************************
*/[
ALTER TABLE [dbo].U_ASS_TT] DROP COLUMN 
	 ASS_MATNUM 
GO


/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_ASS_TT] ADD 
	 ASS_MATNUM numeric(2,0)  NULL 
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_ASS_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_ASS_TT_ASS_MATNUM] DEFAULT (0) FOR [ASS_MATNUM]
go
