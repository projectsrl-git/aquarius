
/* 
*************************************************************************
INSERIMENTO CAMPO NUMBOB (Numero dadi per pallet) IN TABELLA PACKING LIST
*************************************************************************
*/
ALTER TABLE [dbo].[PROD_PACKING] ADD 
	NUMBOB NUMERIC (13,0) NULL,
	NUMBOBPCK NUMERIC (13,0) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[PROD_PACKING] WITH NOCHECK ADD 
	CONSTRAINT [DF_PROD_PACKING_NUMBOB] DEFAULT (0) FOR [NUMBOB],
	CONSTRAINT [DF_PROD_PACKING_NUMBOBPCK] DEFAULT (0) FOR [NUMBOBPCK]
go

UPDATE PROD_PACKING SET NUMBOB = 0
UPDATE PROD_PACKING SET NUMBOBPCK = 0
