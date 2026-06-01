
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_CNT_DD] ADD 
	DAGGANCIO_PR varchar(10) COLLATE Latin1_General_CI_AS NULL


-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_CNT_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_CNT_DD_DAGGANCIO_PR] DEFAULT ('') FOR [DAGGANCIO_PR]
go

UPDATE U_CNT_DD SET DAGGANCIO_PR=SPACE(10)

