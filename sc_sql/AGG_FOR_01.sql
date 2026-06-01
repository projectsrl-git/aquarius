/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_FOR_AN] ADD 
	FOR_OBSOL VARCHAR(1) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default
ALTER TABLE [dbo].[U_FOR_AN] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_FOR_AN_FOR_OBSOL] DEFAULT ('') FOR [FOR_OBSOL]
go

UPDATE U_FOR_AN SET FOR_OBSOL = ''

