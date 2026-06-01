
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
ALTER TABLE [dbo].[U_QUO_AM] ALTER COLUMN
	[QUO_PERORD] [numeric] (8,4) NULL
GO
ALTER TABLE [dbo].[U_QUO_AM] ALTER COLUMN
	[QUO_PERANT] [numeric] (8,4) NULL
GO
ALTER TABLE [dbo].[U_QUO_AM] ALTER COLUMN
	[QUO_PERACC] [numeric] (8,4) NULL
GO
