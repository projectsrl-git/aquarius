/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_AMM_AT] ADD 
	[AMM_VALORD] [numeric] (15,2) NULL ,
	[AMM_VALANT] [numeric] (15,2) NULL ,
	[AMM_VALACC] [numeric] (15,2) NULL ,
	[AMM_TOTAMM] [numeric] (15,2) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_AMM_AT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AMM_AT_AMM_VALORD] DEFAULT (0) FOR [AMM_VALORD],	
	CONSTRAINT [DF_U_AMM_AT_AMM_VALANT] DEFAULT (0) FOR [AMM_VALANT],	
	CONSTRAINT [DF_U_AMM_AT_AMM_VALACC] DEFAULT (0) FOR [AMM_VALACC],	
	CONSTRAINT [DF_U_AMM_AT_AMM_TOTAMM] DEFAULT (0) FOR [AMM_TOTAMM]

go

UPDATE U_AMM_AT SET AMM_VALORD = 0
UPDATE U_AMM_AT SET AMM_VALANT = 0
UPDATE U_AMM_AT SET AMM_VALACC = 0
UPDATE U_AMM_AT SET AMM_TOTAMM = 0

