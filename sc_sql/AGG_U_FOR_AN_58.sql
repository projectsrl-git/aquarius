/*    
***********************************************************************
INSERIMENTO DATI LETTERA INTENTO IN ANAGRAFICA FORNITORI
***********************************************************************
*/


ALTER TABLE [dbo].[U_FOR_AN] ADD 

	 FOR_ALRID varchar(6) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_FOR_AN] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_FOR_AN_FOR_ALRID] DEFAULT ('') FOR [FOR_ALRID]
go



UPDATE U_FOR_AN SET FOR_ALRID = ''