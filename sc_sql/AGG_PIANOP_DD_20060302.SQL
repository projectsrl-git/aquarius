/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[PIANOP_DD] ADD 
	 	 TNUMERO varchar(10) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[PIANOP_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_PIANOP_DD_TNUMERO] DEFAULT ('') FOR [TNUMERO]
go

UPDATE PIANOP_DD SET TNUMERO 	= ''

