/*    
***********************************************************************
INSERIMENTO DATI LETTERA INTENTO IN ANAGRAFICA FORNITORI
***********************************************************************
*/


ALTER TABLE [dbo].[U_FOR_AN] ADD 

	 FOR_VMAXACQ numeric (17,3)

go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_FOR_AN] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_FOR_AN_FOR_VMAXACQ] DEFAULT (0) FOR [FOR_VMAXACQ]
go



UPDATE U_FOR_AN SET FOR_VMAXACQ = 0
