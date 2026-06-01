
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_BFO_DL] ADD 
		 ORD_NUMETI numeric (5,0) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[U_BFO_DL] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_BFO_DL_ORD_NUMETI] DEFAULT (0) FOR [ORD_NUMETI]
go

UPDATE U_BFO_DL SET ORD_NUMETI 	= 0
