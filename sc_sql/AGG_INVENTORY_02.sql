
/* 
**************************************************************
INSERIMENTO NUOVO CAMPO IN TABELLA INVENTORY
**************************************************************
*/
ALTER TABLE [dbo].[INVENTORY] ADD 
	CODCLI varchar(10) COLLATE Latin1_General_CI_AS NULL,
	DESCLI varchar(80) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[INVENTORY] WITH NOCHECK ADD 
	CONSTRAINT [DF_INVENTORY_CODCLI] DEFAULT ('') FOR [CODCLI],
	CONSTRAINT [DF_INVENTORY_DESCLI] DEFAULT ('') FOR [DESCLI]
go

UPDATE INVENTORY SET CODCLI = ''
UPDATE INVENTORY SET DESCLI = ''

