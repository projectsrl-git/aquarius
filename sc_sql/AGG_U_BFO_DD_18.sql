
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_BFO_DD] ADD 
		ORD_QUAPRO varchar(03) COLLATE Latin1_General_CI_AS NULL,
		ORD_CLIENT varchar(10) COLLATE Latin1_General_CI_AS NULL

go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[U_BFO_DD] WITH NOCHECK ADD 
   	    CONSTRAINT [DF_U_BFO_DD_ORD_QUAPRO] DEFAULT ('') FOR [ORD_QUAPRO],
   	    CONSTRAINT [DF_U_BFO_DD_ORD_CLIENT] DEFAULT ('') FOR [ORD_CLIENT]

go

UPDATE U_BFO_DD SET ORD_QUAPRO 	= '' 
UPDATE U_BFO_DD SET ORD_CLIENT 	= '' 