/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[U_ORD_DL] ADD 
	 ORD_SETTCX varchar(07) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_ORD_DL] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_ORD_DL_ORD_SETTCX] DEFAULT ('') FOR [ORD_SETTCX]
go

UPDATE U_ORD_DL SET ORD_SETTCX = SPACE(07)
