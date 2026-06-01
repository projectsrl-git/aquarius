
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_PRG_CL] ADD 
	 PRG_LUNGHE numeric(6) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_PRG_CL] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_PRG_CL_PRG_LUNGHE] DEFAULT (0) FOR [PRG_LUNGHE]
go

UPDATE U_PRG_CL SET PRG_LUNGHE = 0



