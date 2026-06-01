
/* 
**************************************************************
INSERIMENTO NUOVO CAMPO IN TABELLA INVENTORY
**************************************************************
*/
ALTER TABLE [dbo].[INVENTORY] ADD 
	QTANRINV Numeric (12,0) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[INVENTORY] WITH NOCHECK ADD 
	CONSTRAINT [DF_INVENTORY_QTANRINV] DEFAULT (0) FOR [QTANRINV]
go

UPDATE INVENTORY SET QTANRINV = 0


/* 
**************************************************************
ALTERAZIONE DELLA SOLA DIMENSIONE DEL CAMPO
**************************************************************
*/

ALTER TABLE [dbo].[INVENTORY] ALTER COLUMN
	 QTAINV Numeric (19,4) NULL
GO
