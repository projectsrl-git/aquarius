
/* 
****************************************************************************
INSERIMENTO NUOVO CAMPO PER ANAGRAFICA ARTICOLI (TABELLA COMPLEMENTARE):
	- Qta in confezioni (Nr. pezzi)
	  [per poter gestire il numero di dadi per bancale e per poter calcolare 
	   l'equivalenza tra Unità di misura magazzino e Qtà a Numero]
****************************************************************************
*/
ALTER TABLE [dbo].[U_ART_AN] ADD 
	 ART_QTANRC numeric(17,0) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_ART_AN] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_ART_AN_ART_QTANRC] DEFAULT (0) FOR [ART_QTANRC]
go

UPDATE U_ART_AN SET ART_QTANRC = 0


