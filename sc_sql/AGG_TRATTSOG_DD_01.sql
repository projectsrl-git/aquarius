/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[TRATTSOG_DD] ADD 
	 CODATTIVITA varchar(3) COLLATE Latin1_General_CI_AS NULL,
	 DESATTIVITA varchar(254) COLLATE Latin1_General_CI_AS NULL

go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[TRATTSOG_DD] WITH NOCHECK ADD 

	CONSTRAINT [DF_TRATTSOG_DD_CODATTIVITA] DEFAULT ('') FOR [CODATTIVITA],
	CONSTRAINT [DF_TRATTSOG_DD_DESATTIVITA] DEFAULT ('') FOR [DESATTIVITA]
go


UPDATE TRATTSOG_DD SET CODATTIVITA 	= ''
UPDATE TRATTSOG_DD SET DESATTIVITA 	= ''


