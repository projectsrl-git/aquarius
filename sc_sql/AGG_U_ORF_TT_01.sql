
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_ORF_TT] ADD 
		ORD_NUMCOC varchar (30) COLLATE Latin1_General_CI_AS NULL,
		ORD_DATCOC varchar (10) COLLATE Latin1_General_CI_AS NULL,
		ORD_CDC varchar (5) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[U_ORF_TT] WITH NOCHECK ADD 
        CONSTRAINT [DF_U_ORF_TT_ORD_NUMCOC] DEFAULT ('') FOR [ORD_NUMCOC],
        CONSTRAINT [DF_U_ORF_TT_ORD_DATCOC] DEFAULT ('') FOR [ORD_DATCOC],
        CONSTRAINT [DF_U_ORF_TT_ORD_CDC] DEFAULT ('') FOR [ORD_CDC]
go


UPDATE U_ORF_TT SET ORD_NUMCOC 	= ''
UPDATE U_ORF_TT SET ORD_DATCOC 	= ''
UPDATE U_ORF_TT SET ORD_CDC 	= ''

