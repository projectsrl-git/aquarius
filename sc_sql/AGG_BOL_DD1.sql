
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_BOL_DD] ADD 
	 ORD_FORNIT varchar(10) COLLATE Latin1_General_CI_AS NULL,
	 ORD_PRZULC [numeric](17, 6) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_BOL_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_BOL_DD_ORD_FORNIT] DEFAULT ('') FOR [ORD_FORNIT],
	CONSTRAINT [DF_U_BOL_DD_ORD_PRZULC] DEFAULT (0) FOR [ORD_PRZULC]
go
