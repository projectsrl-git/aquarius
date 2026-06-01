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
ALTER TABLE [dbo].[U_FOR_AN] ALTER COLUMN
	 FOR_CDIBAN varchar(29) COLLATE Latin1_General_CI_AS NULL
GO
ALTER TABLE [dbo].[U_FOR_AN] ALTER COLUMN
	 FOR_CODCHE varchar(2) COLLATE Latin1_General_CI_AS NULL
GO