
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_ORF_DD] ADD 
		ORD_NUMRDA varchar (10) COLLATE Latin1_General_CI_AS NULL,
		ORD_DATRDA varchar (10) COLLATE Latin1_General_CI_AS NULL
go

ALTER TABLE [dbo].[U_ORF_DD] WITH NOCHECK ADD 
        CONSTRAINT [DF_U_ORF_DD_ORD_NUMRDA] DEFAULT ('') FOR [ORD_NUMRDA],
        CONSTRAINT [DF_U_ORF_DD_ORD_DATRDA] DEFAULT ('') FOR [ORD_DATRDA]
go

UPDATE U_ORF_DD SET ORD_NUMRDA = ''
UPDATE U_ORF_DD SET ORD_DATRDA = ''
