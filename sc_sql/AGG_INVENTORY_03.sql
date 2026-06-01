
/* 
**************************************************************
INSERIMENTO NUOVO CAMPO IN TABELLA INVENTORY
**************************************************************
*/
ALTER TABLE [dbo].[INVENTORY] ADD 
	CODQUA varchar(03) COLLATE Latin1_General_CI_AS NULL,
	DESQUA varchar(80) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[INVENTORY] WITH NOCHECK ADD 
	CONSTRAINT [DF_INVENTORY_CODQUA] DEFAULT ('') FOR [CODQUA],
	CONSTRAINT [DF_INVENTORY_DESQUA] DEFAULT ('') FOR [DESQUA]
go

UPDATE INVENTORY SET CODQUA = ''
UPDATE INVENTORY SET DESQUA = ''

