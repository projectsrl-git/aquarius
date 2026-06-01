/*    
***********************************************************************
INSERIMENTO DATI LETTERA INTENTO IN ANAGRAFICA FORNITORI
***********************************************************************
*/


ALTER TABLE [dbo].[U_FOR_AN] ADD 

	 for_bswfor varchar(100) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_FOR_AN] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_FOR_AN_for_bswfor] DEFAULT ('') FOR [for_bswfor]
go



UPDATE U_FOR_AN SET for_bswfor = ''