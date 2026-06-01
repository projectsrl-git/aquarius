/* 
**************************************************************************
INSERIRE NUOVI CAMPI IN DETTAGLI DOCUMENTI DI CARICO DA FORNITORE:
**************************************************************************
- ORD_SYSCTL: Identificativo univoco per legame con giacenza sul magazzino esterno di conto lavoro
- ORD_NRPZFR: Numero fogli fronte (per ordine carte impregnate)
- ORD_NRPZRE: Numero fogli retro (per ordine carte impregnate)
- ORD_QTACTL: Quantità impegnata su giacenza sul magazzino esterno di conto lavoro
**************************************************************************
*/
ALTER TABLE [dbo].[U_BFO_DD] ADD 
	ORD_SYSCTL varchar (10) COLLATE Latin1_General_CI_AS NULL,
	ORD_NRPZFR numeric (10,0) NULL,
	ORD_NRPZRE numeric (10,0) NULL,
	ORD_QTACTL numeric (17,4) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[U_BFO_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_BFO_DD_ORD_SYSCTL] DEFAULT ('') FOR [ORD_SYSCTL],
	CONSTRAINT [DF_U_BFO_DD_ORD_NRPZFR] DEFAULT (0) FOR [ORD_NRPZFR],
	CONSTRAINT [DF_U_BFO_DD_ORD_NRPZRE] DEFAULT (0) FOR [ORD_NRPZRE],
	CONSTRAINT [DF_U_BFO_DD_ORD_QTACTL] DEFAULT (0) FOR [ORD_QTACTL]
go

UPDATE U_BFO_DD SET ORD_SYSCTL = ''
UPDATE U_BFO_DD SET ORD_NRPZFR = 0
UPDATE U_BFO_DD SET ORD_NRPZRE = 0
UPDATE U_BFO_DD SET ORD_QTACTL = 0
