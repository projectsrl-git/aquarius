
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[L_BOL_TT] ADD 
		ORD_NUMCOC varchar (30) COLLATE Latin1_General_CI_AS NULL,
		ORD_DATCOC varchar (10) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[L_BOL_TT] WITH NOCHECK ADD 
        CONSTRAINT [DF_L_BOL_TT_ORD_NUMCOC] DEFAULT ('') FOR [ORD_NUMCOC],
        CONSTRAINT [DF_L_BOL_TT_ORD_DATCOC] DEFAULT ('') FOR [ORD_DATCOC]
go



UPDATE L_BOL_TT SET ORD_NUMCOC 	= ''
UPDATE L_BOL_TT SET ORD_DATCOC 	= ''

