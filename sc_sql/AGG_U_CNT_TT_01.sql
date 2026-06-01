
ALTER TABLE [dbo].[U_CNT_TT] ADD 
	 ORD_CPA varchar(3) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_CNT_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_CNT_TT_ORD_CPA] DEFAULT ('') FOR [ORD_CPA]
go

UPDATE U_CNT_TT SET ORD_CPA = ''
