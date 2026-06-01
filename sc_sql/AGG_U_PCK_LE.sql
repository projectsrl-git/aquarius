/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[U_PCK_LE] ADD 
	 LEG_SCARIC bit NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_PCK_LE] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_PCK_LE_LEG_SCARIC] DEFAULT (0) FOR [LEG_SCARIC]
go

UPDATE U_PCK_LE SET LEG_SCARIC = 0
