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
ALTER TABLE [dbo].[U_CLI_AN] ALTER COLUMN
	 CLI_CDIBAN varchar(29) COLLATE Latin1_General_CI_AS NULL
GO
ALTER TABLE [dbo].[U_CLI_AN] ALTER COLUMN
	 CLI_IBAFOR varchar(29) COLLATE Latin1_General_CI_AS NULL
GO
ALTER TABLE [dbo].[U_CLI_AN] ALTER COLUMN
	 CLI_CODCHE varchar(2) COLLATE Latin1_General_CI_AS NULL
GO
ALTER TABLE [dbo].[U_CLI_AN] ALTER COLUMN
	 CLI_CHEFOR varchar(2) COLLATE Latin1_General_CI_AS NULL
GO