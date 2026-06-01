
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_CNT_PR] ADD 
	CNT_LUNGHE numeric(8,0) NULL

-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_CNT_PR] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_CNT_PR_CNT_LUNGHE] DEFAULT 0 FOR [CNT_LUNGHE]
go

UPDATE U_CNT_PR SET CNT_LUNGHE = 0




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
ALTER TABLE [dbo].[U_CNT_PR] ALTER COLUMN
	 CNT_CODDES varchar(06) COLLATE Latin1_General_CI_AS NULL 
GO

UPDATE U_CNT_PR SET CNT_CODDES = SPACE(06)