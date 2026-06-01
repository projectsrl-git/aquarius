/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_ART_PR] ADD 
	 	 ART_NAZMER varchar(2) COLLATE Latin1_General_CI_AS NULL
 
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_ART_PR] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_ART_PR_ART_NAZMER] DEFAULT (' ') FOR [ART_NAZMER]
go

UPDATE U_ART_PR SET ART_NAZMER = ' '


