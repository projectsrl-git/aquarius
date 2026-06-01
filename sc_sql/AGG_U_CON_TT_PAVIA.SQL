
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_CON_TT] ADD 
	 CON_DOCU varchar(150) COLLATE Latin1_General_CI_AS NULL
	
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_CON_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_CON_TT_CON_DOCU] DEFAULT ('') FOR [CON_DOCU]
	
go

UPDATE U_CON_TT SET CON_DOCU = ''