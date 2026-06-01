
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_MRI_TT] ADD 
	 ORD_FLDFA varchar(1) COLLATE Latin1_General_CI_AS NULL ,
	 ORD_FLFAT varchar(1) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_MRI_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_MRI_TT_ORD_FLDFA] DEFAULT ('') FOR [ORD_FLDFA],
	CONSTRAINT [DF_U_MRI_TT_ORD_FLFAT] DEFAULT ('') FOR [ORD_FLFAT]
go


/* 
**************************************************************
COME CANCELLARE UN CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_MRI_TT] DROP COLUMN 
	 ORD_FLDFA ,
	 ORD_FLFAT 
GO


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
ALTER TABLE [dbo].[U_MRI_TT] ALTER COLUMN
	 TAGGANCIO varchar(10) COLLATE Latin1_General_CI_AS NULL 
GO










