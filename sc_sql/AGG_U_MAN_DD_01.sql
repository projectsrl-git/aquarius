/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_MAN_DD] ADD 
	 	 RIC_NPART numeric(10,0)  NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_MAN_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_MAN_DD_RIC_NPART] DEFAULT  (0) FOR [RIC_NPART]
go

UPDATE U_MAN_DD SET RIC_NPART		= 0
