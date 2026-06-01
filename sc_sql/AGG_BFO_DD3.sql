
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_BFO_DD] ADD 
	 ORD_DTASCA varchar(10) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_BFO_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_BFO_DD_ORD_DTASCA] DEFAULT ('') FOR [ORD_DTASCA]
go

UPDATE U_BFO_DD SET ORD_DTASCA = SPACE(10)
