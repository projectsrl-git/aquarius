/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_DIS_DD] ADD 
	 DIS_SYSDD varchar(10) COLLATE Latin1_General_CI_AS NULL

go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[U_DIS_DD] WITH NOCHECK ADD 

	CONSTRAINT [DF_U_DIS_DD_DIS_SYSDD] DEFAULT ('') FOR [DIS_SYSDD]
go


UPDATE U_DIS_DD SET DIS_SYSDD 	= ''
