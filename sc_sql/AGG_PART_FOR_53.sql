
/* 
*******************************************************************
ALLARGAMENTO CAMPO DESCRIZIONE MODIFICABILE IN PARTITARIO FORNITORI
*******************************************************************
*/
ALTER TABLE [dbo].[PART_FOR] ALTER COLUMN 
	PAR_DESMO1 varchar(254) COLLATE Latin1_General_CI_AS NULL
go
