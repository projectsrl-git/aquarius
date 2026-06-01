
/* 
***************************************************************
INSERIMENTO CAMPO "QUANTITA' MC DA EVADERE" PER EVASIONE ORDINI
***************************************************************
*/
ALTER TABLE [dbo].[U_ORD_DD] ADD 
	ORD_NOTEPRO varchar (100) NULL,
	ORD_NOTESPE varchar (100) NULL,
	ORD_NOTEVAR varchar (100) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[U_ORD_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_ORD_DD_ORD_NOTEPRO] DEFAULT ('') FOR [ORD_NOTEPRO],
	CONSTRAINT [DF_U_ORD_DD_ORD_NOTESPE] DEFAULT ('') FOR [ORD_NOTESPE],
	CONSTRAINT [DF_U_ORD_DD_ORD_NOTEVAR] DEFAULT ('') FOR [ORD_NOTEVAR]
go

UPDATE U_ORD_DD SET ORD_NOTEPRO = ''
UPDATE U_ORD_DD SET ORD_NOTESPE = ''
UPDATE U_ORD_DD SET ORD_NOTEVAR = ''

