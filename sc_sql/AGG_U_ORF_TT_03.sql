
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_ORF_TT] ADD 
		ORD_NRDATT varchar (10) COLLATE Latin1_General_CI_AS NULL,
		ORD_DRDATT varchar (10) COLLATE Latin1_General_CI_AS NULL
go

ALTER TABLE [dbo].[U_ORF_TT] WITH NOCHECK ADD 
        CONSTRAINT [DF_U_ORF_TT_ORD_NRDATT] DEFAULT ('') FOR [ORD_NRDATT],
        CONSTRAINT [DF_U_ORF_TT_ORD_DRDATT] DEFAULT ('') FOR [ORD_DRDATT]
go

UPDATE U_ORF_TT SET ORD_NRDATT = ''
UPDATE U_ORF_TT SET ORD_DRDATT = ''
