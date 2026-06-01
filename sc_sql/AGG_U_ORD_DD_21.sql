
/* 
***************************************************************
INSERIMENTO CAMPO "QUANTITA' MC DA EVADERE" PER EVASIONE ORDINI
***************************************************************
*/
ALTER TABLE [dbo].[U_ORD_DD] ADD 
	ORD_QTADEV3 numeric (17,4) NULL,
	ORD_NUMBOD3 numeric (6,0) NULL,
	ORD_NRIGAP numeric (10,0) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[U_ORD_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_ORD_DD_ORD_QTADEV3] DEFAULT (0) FOR [ORD_QTADEV3],
	CONSTRAINT [DF_U_ORD_DD_ORD_NUMBOD3] DEFAULT (0) FOR [ORD_NUMBOD3],
	CONSTRAINT [DF_U_ORD_DD_ORD_NRIGAP] DEFAULT (0) FOR [ORD_NRIGAP]
go

UPDATE U_ORD_DD SET ORD_QTADEV3 = 0 
UPDATE U_ORD_DD SET ORD_NUMBOD3 = 0 
UPDATE U_ORD_DD SET ORD_NRIGAP = 0 
