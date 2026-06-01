
/* 
**************************************************************************************************************
ALLARGAMENTO CAMPO NUMERO FATTURA IN TABELLE FATTURE PROFESSIONISTI
**************************************************************************************************************
*/
ALTER TABLE [dbo].[U_RIA_TT] ALTER COLUMN
	ORD_NUMORD varchar(20) COLLATE Latin1_General_CI_AS NULL
go
