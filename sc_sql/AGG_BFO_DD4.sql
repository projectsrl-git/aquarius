
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_BFO_DD] ADD 
	 ORD_LEGASY varchar(10) COLLATE Latin1_General_CI_AS NULL,
	 ORD_SALCON varchar(1) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_BFO_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_BFO_DD_ORD_LEGASY] DEFAULT ('') FOR [ORD_LEGASY],
	CONSTRAINT [DF_U_BFO_DD_ORD_SALCON] DEFAULT ('') FOR [ORD_SALCON]
go

UPDATE U_BFO_DD SET ORD_LEGASY = SPACE(10)
UPDATE U_BFO_DD SET ORD_SALCON = SPACE(1)
