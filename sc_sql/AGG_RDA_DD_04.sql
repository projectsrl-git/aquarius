
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[RDA_DD] ADD 
	 CCOSTO varchar(13) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[RDA_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_RDA_DD_CCOSTO] DEFAULT ('') FOR [CCOSTO]
go

UPDATE RDA_DD SET CCOSTO = ''
