/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[FATTURABILE_P] ADD 
	 ORD_EPEC varchar(200) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[FATTURABILE_P] WITH NOCHECK ADD 

	CONSTRAINT [DF_FATTURABILE_P_ORD_EPEC] DEFAULT ('') FOR [ORD_EPEC]

go

UPDATE FATTURABILE_P SET ORD_EPEC = ''
