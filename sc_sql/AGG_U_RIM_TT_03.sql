
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_RIM_DD] ADD 
	 RIC_NEWPAR NUMERIC (10,0) NULL
	 
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_RIM_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_RIM_DD_RIC_NEWPAR] DEFAULT (0) FOR [RIC_NEWPAR]
	go

UPDATE U_RIM_DD SET RIC_NEWPAR=0