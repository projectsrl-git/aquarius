
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
ALTER TABLE [dbo].[pjtiprep] ALTER COLUMN
	 NOMEREP varchar(20) COLLATE Latin1_General_CI_AS NULL
GO

ALTER TABLE [dbo].[pjtiprep] ALTER COLUMN
	 NOMEREP2 varchar(20) COLLATE Latin1_General_CI_AS NULL
GO

ALTER TABLE [dbo].[pjtiprep] ALTER COLUMN
	 NOMEREP3 varchar(20) COLLATE Latin1_General_CI_AS NULL
GO

ALTER TABLE [dbo].[pjtiprep] ALTER COLUMN
	 NOMEREP4 varchar(20) COLLATE Latin1_General_CI_AS NULL
GO
