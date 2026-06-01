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
ALTER TABLE [dbo].[U_PAR_CQ] ALTER COLUMN PAR_GRAMDA [numeric](5,1) NULL

ALTER TABLE [dbo].[U_PAR_CQ] ALTER COLUMN PAR_GRAMAL [numeric](5,1) NULL

ALTER TABLE [dbo].[U_PAR_CQ] ALTER COLUMN PAR_PHDA [numeric](6,2) NULL 

ALTER TABLE [dbo].[U_PAR_CQ] ALTER COLUMN PAR_PHAL [numeric](6,2) NULL 

GO