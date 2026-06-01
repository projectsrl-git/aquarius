/* 
**************************************************************************
INSERIRE NUOVI CAMPI IN DETTAGLI ORDINI A FORNITORE:
**************************************************************************
- ORF_SYSCTL: Identificativo univoco per legame con ordini in conto lavoro
- ORF_NRPZFR: Numero fogli fronte (per ordine carte impregnate)
- ORF_NRPZRE: Numero fogli retro (per ordine carte impregnate)
**************************************************************************
*/
ALTER TABLE [dbo].[U_ORF_DD] ADD 
	ORD_SYSCTL varchar (10) COLLATE Latin1_General_CI_AS NULL,
	ORD_NRPZFR numeric (10,0) NULL,
	ORD_NRPZRE numeric (10,0) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[U_ORF_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_ORF_DD_ORD_SYSCTL] DEFAULT ('') FOR [ORD_SYSCTL],
	CONSTRAINT [DF_U_ORF_DD_ORD_NRPZFR] DEFAULT (0) FOR [ORD_NRPZFR],
	CONSTRAINT [DF_U_ORF_DD_ORD_NRPZRE] DEFAULT (0) FOR [ORD_NRPZRE]
go

UPDATE U_ORF_DD SET ORD_SYSCTL = ''
UPDATE U_ORF_DD SET ORD_NRPZFR = 0
UPDATE U_ORF_DD SET ORD_NRPZRE = 0
