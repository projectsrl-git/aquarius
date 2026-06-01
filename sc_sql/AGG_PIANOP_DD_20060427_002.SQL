/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[PIANOP_DD] ADD 
	 	 CREATOCBI varchar(2) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[PIANOP_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_PIANOP_DD_CREATOCBI] DEFAULT ('') FOR [CREATOCBI]
go

UPDATE PIANOP_DD SET CREATOCBI 	= ''

