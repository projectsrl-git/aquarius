
/* 
***************************************************************
INSERIMENTO CAMPO "QUANTITA' MC DA EVADERE" PER EVASIONE ORDINI
***************************************************************
*/
ALTER TABLE [dbo].[U_ORD_DD] ADD 
	ORD_QTADEV2 numeric (17,4) NULL,
	ORD_NUMBOD2 numeric (6,0) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[U_ORD_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_ORD_DD_ORD_QTADEV2] DEFAULT (0) FOR [ORD_QTADEV2],
	CONSTRAINT [DF_U_ORD_DD_ORD_NUMBOD2] DEFAULT (0) FOR [ORD_NUMBOD2]
go

UPDATE U_ORD_DD SET ORD_QTADEV2 = 0 
UPDATE U_ORD_DD SET ORD_NUMBOD2 = 0 
