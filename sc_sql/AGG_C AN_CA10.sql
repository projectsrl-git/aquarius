
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_CAN_CA] ADD 
	[CAS_FLGAGG] [bit] NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_CAN_CA] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_CAN_CA_CAS_FLGAGG] DEFAULT (0) FOR [CAS_FLGAGG]
go
