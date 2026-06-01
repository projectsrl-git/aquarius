
/* 
***************************************************************
INSERIMENTO CAMPO "QUANTITA' MC DA EVADERE" PER EVASIONE ORDINI
***************************************************************
*/
ALTER TABLE [dbo].[U_ORD_DD] ADD 
		 ORD_QTAMCD numeric (17,3) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[U_ORD_DD] WITH NOCHECK ADD 
        CONSTRAINT [DF_U_ORD_DD_ORD_QTAMCD] DEFAULT ('0') FOR [ORD_QTAMCD]
go

UPDATE U_ORD_DD SET ORD_QTAMCD = 0 
