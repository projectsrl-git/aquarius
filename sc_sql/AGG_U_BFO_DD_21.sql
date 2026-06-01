/***************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
***************************************************************/

ALTER TABLE [dbo].[U_BFO_DD] ADD 
	ORD_DTACOL varchar(10) COLLATE Latin1_General_CI_AS NULL
go

ALTER TABLE [dbo].[U_BFO_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_BFO_DD_ORD_DTACOL] DEFAULT ('') FOR [ORD_DTACOL]
go

UPDATE U_BFO_DD SET ORD_DTACOL = '' 
