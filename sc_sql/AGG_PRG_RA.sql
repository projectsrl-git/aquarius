/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[U_PRG_RA] ADD 
	 ADE_QTASCA numeric(20,6) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_PRG_RA] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_PRG_RA_ADE_QTASCA] DEFAULT (0) FOR [ADE_QTASCA]
go

UPDATE U_PRG_RA SET ADE_QTASCA = 0
