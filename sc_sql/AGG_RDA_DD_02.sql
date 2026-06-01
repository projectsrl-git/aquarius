/***************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
***************************************************************/

ALTER TABLE [dbo].[RDA_DD] ADD 
	RICHIEDENTE varchar(3) COLLATE Latin1_General_CI_AS NULL
go

ALTER TABLE [dbo].[RDA_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_RDA_DD_RICHIEDENTE] DEFAULT ('') FOR [RICHIEDENTE]
go


UPDATE RDA_DD SET RICHIEDENTE = '' 

