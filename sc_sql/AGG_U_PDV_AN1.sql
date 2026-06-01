
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_PDV_AN] ADD 
	 SELEZIONE varchar(10) COLLATE Latin1_General_CI_AS NULL
	 
go
ALTER TABLE [dbo].[U_PDV_AN] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_PDV_AN_SELEZIONE] DEFAULT ('') FOR [SELEZIONE]
	

go
