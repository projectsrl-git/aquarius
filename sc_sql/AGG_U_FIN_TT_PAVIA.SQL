
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_FIN_TT] ADD 
	 FIN_DOCU varchar(150) COLLATE Latin1_General_CI_AS NULL
	
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_FIN_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_FIN_TT_FIN_DOCU] DEFAULT ('') FOR [FIN_DOCU]
	
go

UPDATE U_FIN_TT SET FIN_DOCU = ''