/* 
**************************************************************
COME MODIFICARE UN CAMPO ESISTENTE IN UNA TABELLA
**************************************************************

ATTENZIONE!!!!!
SE LA VARIAZIONE COMPORTA UNA RIDUZIONE DELLE DIMENSIONI DEL CAMPO,
SQL LO PERMETTE SOLO SE LA DIMENSIONE DEL DATO CONTENUTO E' 
UGUALE O INFERIORE ALLA NUOVA DIMENSIONE (SU TUTTI I RECORD
PRESENTI IN TABELLA)
**************************************************************
*/
ALTER TABLE [dbo].[U_BFO_DD] ALTER COLUMN
	 MOV_RAGORD varchar(120) COLLATE Latin1_General_CI_AS NULL 
GO

/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_BFO_DD] ADD 
	 	 CBF_NREGIS varchar(10) COLLATE Latin1_General_CI_AS NULL,
	 	 CBF_DTREG varchar(10) COLLATE Latin1_General_CI_AS NULL,
	 	 CBF_NUMPRO varchar(10) COLLATE Latin1_General_CI_AS NULL,
	 	 CBF_NDOC varchar(10) COLLATE Latin1_General_CI_AS NULL,
	 	 CBF_DTDOC varchar(10) COLLATE Latin1_General_CI_AS NULL,
		 CBF_NPART numeric (10,0) NULL,
		 CBF_IMP numeric (18,2) NULL,
	 	 CBF_CODFOR varchar(13) COLLATE Latin1_General_CI_AS NULL

go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[U_BFO_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_BFO_DD_CBF_NREGIS] DEFAULT ('    ') FOR [CBF_NREGIS],
	CONSTRAINT [DF_U_BFO_DD_CBF_DTREG] DEFAULT ('    ') FOR [CBF_DTREG],
	CONSTRAINT [DF_U_BFO_DD_CBF_NUMPRO] DEFAULT ('    ') FOR [CBF_NUMPRO],
	CONSTRAINT [DF_U_BFO_DD_CBF_NDOC] DEFAULT ('    ') FOR [CBF_NDOC],
	CONSTRAINT [DF_U_BFO_DD_CBF_DTDOC] DEFAULT ('    ') FOR [CBF_DTDOC],
	CONSTRAINT [DF_U_BFO_DD_CBF_NPART] DEFAULT ('0') FOR [CBF_NPART],
	CONSTRAINT [DF_U_BFO_DD_CBF_IMP] DEFAULT ('0') FOR [CBF_IMP],
	CONSTRAINT [DF_U_BFO_DD_CBF_CODFOR] DEFAULT ('    ') FOR [CBF_CODFOR]
go



UPDATE U_BFO_DD SET CBF_NDOC 	= ' ' 
UPDATE U_BFO_DD SET CBF_DTDOC 	= ' ' 
UPDATE U_BFO_DD SET CBF_CODFOR 	= ' ' 

UPDATE U_BFO_DD SET CBF_NREGIS 	= ' ' 
UPDATE U_BFO_DD SET CBF_DTREG 	= ' ' 
UPDATE U_BFO_DD SET CBF_NUMPRO 	= ' ' 

UPDATE U_BFO_DD SET CBF_IMP 	= 0 
UPDATE U_BFO_DD SET CBF_NPART 	= 0 