
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_PDV_CC] ADD 
	 PDV_DESNOT varchar(50) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_PDV_CC] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_PDV_CC_PDV_DESNOT] DEFAULT ('') FOR [PDV_DESNOT]
go
