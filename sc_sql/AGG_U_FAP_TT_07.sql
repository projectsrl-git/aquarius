
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_FAP_TT] ADD 
		ORD_CONINC varchar (16) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[U_FAP_TT] WITH NOCHECK ADD 
        CONSTRAINT [DF_U_FAP_TT_ORD_CONINC] DEFAULT ('') FOR [ORD_CONINC]
go



ALTER TABLE [dbo].[U_FAP_TT] ADD 
        ORD_INCASS [bit] NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_FAP_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_FAP_TT_ORD_INCASS] DEFAULT (0) FOR [ORD_INCASS]

go


UPDATE U_FAP_TT SET ORD_CONINC 	= ''
UPDATE U_FAP_TT SET ORD_INCASS = 0

