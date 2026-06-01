
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[VENDITE_TT] ADD 
		ORD_CCODSCHE varchar (20) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[VENDITE_TT] WITH NOCHECK ADD 
        CONSTRAINT [DF_VENDITE_TT_ORD_CCODSCHE] DEFAULT ('') FOR [ORD_CCODSCHE]
go



UPDATE VENDITE_TT SET ORD_CCODSCHE 	= ''
