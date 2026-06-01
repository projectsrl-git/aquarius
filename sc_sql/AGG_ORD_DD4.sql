/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[U_ORD_DD] ADD 
	 ORD_SETTCC varchar(07) COLLATE Latin1_General_CI_AS NULL,
	 ORD_NRBOBX numeric(6) NULL,
	 ORD_QUANTX numeric(11,2) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_ORD_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_ORD_DD_ORD_SETTCC] DEFAULT ('') FOR [ORD_SETTCC],
	CONSTRAINT [DF_U_ORD_DD_ORD_NRBOBX] DEFAULT (0) FOR [ORD_NRBOBX],
	CONSTRAINT [DF_U_ORD_DD_ORD_QUANTX] DEFAULT (0) FOR [ORD_QUANTX]
go

UPDATE U_ORD_DD SET ORD_SETTCC = SPACE(07)
UPDATE U_ORD_DD SET ORD_NRBOBX = 0
UPDATE U_ORD_DD SET ORD_QUANTX = 0
