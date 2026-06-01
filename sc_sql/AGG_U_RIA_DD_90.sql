/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_RIA_DD] ADD 
	 	 ORD_NOCALC4PE varchar(10) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_RIA_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_RIA_DD_ORD_NOCALC4PE] DEFAULT  (' ') FOR [ORD_NOCALC4PE]

go

UPDATE U_RIA_DD SET ORD_NOCALC4PE		= '  '
