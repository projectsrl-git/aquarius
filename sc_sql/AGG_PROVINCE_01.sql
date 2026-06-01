
/* 
***************************************************************
INSERIMENTO CAMPO "QUANTITA' MC DA EVADERE" PER EVASIONE ORDINI
***************************************************************
*/
ALTER TABLE [dbo].[PROVINCE] ADD 
	PRV_COSTOT numeric (17,4) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[PROVINCE] WITH NOCHECK ADD 
	CONSTRAINT [DF_PROVINCE_PRV_COSTOT] DEFAULT (0) FOR [PRV_COSTOT]
go

UPDATE PROVINCE SET PRV_COSTOT = 0 

