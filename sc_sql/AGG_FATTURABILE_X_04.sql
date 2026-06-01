/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[FATTURABILE_X] ADD 
	 ORD_EPEC varchar(200) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[FATTURABILE_X] WITH NOCHECK ADD 

	CONSTRAINT [DF_FATTURABILE_X_ORD_EPEC] DEFAULT ('') FOR [ORD_EPEC]

go

UPDATE FATTURABILE_X SET ORD_EPEC = ''
