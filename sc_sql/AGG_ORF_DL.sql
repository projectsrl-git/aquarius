/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[U_ORF_DL] ADD 
	 ORD_ALTCOM numeric(5) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_ORF_DL] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_ORF_DL_ORD_ALTCOM] DEFAULT (0) FOR [ORD_ALTCOM]
go

UPDATE U_ORF_DL SET ORD_ALTCOM = 0
