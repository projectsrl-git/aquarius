/*    
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[U_LOC_AN] ADD 
	 LOC_GGEVAS numeric (3,0) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_LOC_AN] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_LOC_AN_LOC_GGEVAS] DEFAULT ('0') FOR [LOC_GGEVAS]
go

UPDATE U_LOC_AN SET LOC_GGEVAS = 0

