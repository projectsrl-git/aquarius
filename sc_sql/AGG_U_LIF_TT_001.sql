/*
*/

ALTER TABLE [dbo].[U_LIF_TT] ADD 

	 lif_artfor varchar(16) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_LIF_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_LIF_TT_lif_artfor] DEFAULT ('') FOR [lif_artfor]
go



UPDATE U_LIF_TT SET lif_artfor = ''

