
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[U_PDV_IN] ADD 
	 CGE_CODIVA varchar(03) COLLATE Latin1_General_CI_AS NULL

go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_PDV_IN] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_PDV_IN_CGE_CODIVA] DEFAULT ('') FOR [CGE_CODIVA]
go