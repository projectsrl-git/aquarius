/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[FATTURABILE_S] ADD 
	 ORD_EPEC varchar(200) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[FATTURABILE_S] WITH NOCHECK ADD 

	CONSTRAINT [DF_FATTURABILE_S_ORD_EPEC] DEFAULT ('') FOR [ORD_EPEC]

go

UPDATE FATTURABILE_S SET ORD_EPEC = ''
