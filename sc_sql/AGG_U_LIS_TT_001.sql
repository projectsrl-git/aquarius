/*
*/

ALTER TABLE [dbo].[U_LIS_TT] ADD 

	 lis_valuta varchar(3) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_LIS_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_LIS_TT_lis_valuta] DEFAULT ('') FOR [lis_valuta]
go



UPDATE U_LIS_TT SET lis_valuta = ''

