
/* 
**************************************************************
INSERIMENTO DEL/I NUOVO CAMPO PROVINCIA SUI DOCUMENTI
**************************************************************
*/
ALTER TABLE [dbo].[U_BFO_TT] ADD 
	 ORD_PROC varchar(2) COLLATE Latin1_General_CI_AS NULL
go
ALTER TABLE [dbo].[U_BFO_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_BFO_TT_ORD_PROC] DEFAULT ('') FOR [ORD_PROC]
go
