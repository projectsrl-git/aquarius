
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[U_ORF_DD] ADD 
	 ORD_FULFIL BIT NOT NULL CONSTRAINT [DF_U_ORF_DD_ORD_FULFIL] DEFAULT (0)

go
