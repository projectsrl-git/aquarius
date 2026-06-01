
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_PNC_SA] ADD 
	 PNC_CODBUN varchar(10) COLLATE Latin1_General_CI_AS NULL ,
	 PNC_DESBUN varchar(50) COLLATE Latin1_General_CI_AS NULL ,
	 PNC_FLGTRA [bit] NULL 
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_PNC_SA] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_PNC_SA_PNC_CODBUN] DEFAULT ('') FOR [PNC_CODBUN],
	CONSTRAINT [DF_U_PNC_SA_PNC_DESBUN] DEFAULT ('') FOR [PNC_DESBUN],
	CONSTRAINT [DF_U_PNC_SA_PNC_FLGTRA] DEFAULT (0) FOR [PNC_FLGTRA]
go
