/* 
*****************************************************************************
INSERIMENTO NUOVO CAMPO 'COSTO MEDIO' IN TABELLA BUDGET PER ENTRATO FORNITORI
*****************************************************************************
*/
ALTER TABLE [dbo].[BUDENTRFOR] ADD 
	COSTOMED numeric(17,6) NULL
go

ALTER TABLE [dbo].[BUDENTRFOR] WITH NOCHECK ADD 
	CONSTRAINT [DF_BUDENTRFOR_COSTOMED] DEFAULT (0) FOR [COSTOMED]
go

UPDATE BUDENTRFOR SET COSTOMED = 0
