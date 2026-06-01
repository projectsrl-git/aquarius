
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[L_BOL_TT] ADD 
	 ORD_BOLLATOIVA varchar(1) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[L_BOL_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_L_BOL_TT_ORD_BOLLATOIVA] DEFAULT ('') FOR [ORD_BOLLATOIVA]
go

UPDATE L_BOL_TT SET ORD_BOLLATOIVA = ''
