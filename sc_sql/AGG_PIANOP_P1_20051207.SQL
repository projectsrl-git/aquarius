/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[PIANOP_P1] ADD 
	 	 NUMEROFATT varchar(10) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[PIANOP_P1] WITH NOCHECK ADD 
	CONSTRAINT [DF_PIANOP_P1_NUMEROFATT] DEFAULT ('') FOR [NUMEROFATT]
go

UPDATE PIANOP_P1 SET NUMEROFATT 	= ''

