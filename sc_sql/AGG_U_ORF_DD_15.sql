/* 
**************************************************************************
INSERIRE NUOVO CAMPO IN DETTAGLI ORDINI A FORNITORE:
**************************************************************************
- ORD_QTACTL: Quantità impegnata dal magazzino per ordini in conto lavoro
**************************************************************************
*/
ALTER TABLE [dbo].[U_ORF_DD] ADD 
	ORD_QTACTL numeric (17,4) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[U_ORF_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_ORF_DD_ORD_QTACTL] DEFAULT (0) FOR [ORD_QTACTL]
go

UPDATE U_ORF_DD SET ORD_QTACTL = 0
