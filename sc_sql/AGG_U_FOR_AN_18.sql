/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_FOR_AN] ADD 
		 FOR_LEADTMP numeric (17,3) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_FOR_AN] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_PCK_DD_FOR_LEADTMP] DEFAULT ('0')    FOR [FOR_LEADTMP]
go

UPDATE U_FOR_AN SET FOR_LEADTMP 	= 0
