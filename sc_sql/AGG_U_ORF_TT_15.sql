
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_ORF_TT] ADD 
	ORD_IMBALL text NULL
go

ALTER TABLE [dbo].[U_ORF_TT] WITH NOCHECK ADD 
        CONSTRAINT [DF_U_ORF_TT_ORD_IMBALL] DEFAULT ('') FOR [ORD_IMBALL]
go

UPDATE U_ORF_TT SET ORD_IMBALL = ''

