   
/* 
**************************************************************
INSERIMENTO NUOVO CAMPO IN TABELLA INVENTORY
**************************************************************
*/
ALTER TABLE [dbo].[INVENTORY] ADD 
	ELABORATO varchar(02) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[INVENTORY] WITH NOCHECK ADD 
	CONSTRAINT [DF_INVENTORY_ELABORATO] DEFAULT ('') FOR [ELABORATO]
go

UPDATE INVENTORY SET ELABORATO = ''


