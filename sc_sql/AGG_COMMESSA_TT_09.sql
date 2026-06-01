/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[COMMESSA_TT] ADD 
	 ORD_EPEC varchar(200) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[COMMESSA_TT] WITH NOCHECK ADD 

	CONSTRAINT [DF_COMMESSA_TT_ORD_EPEC] DEFAULT ('') FOR [ORD_EPEC]

go

UPDATE COMMESSA_TT SET ORD_EPEC = ''
