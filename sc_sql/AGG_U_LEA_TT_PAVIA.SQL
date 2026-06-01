
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_LEA_TT] ADD 
	 LEA_DOCU varchar(150) COLLATE Latin1_General_CI_AS NULL
	
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_LEA_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_LEA_TT_LEA_DOCU] DEFAULT ('') FOR [LEA_DOCU]
	
go

UPDATE U_LEA_TT SET LEA_DOCU = ''