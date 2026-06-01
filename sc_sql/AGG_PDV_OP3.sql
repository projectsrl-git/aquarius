
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_PDV_OP] ADD 
	 CAS_DESNOT varchar(50) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_PDV_OP] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_PDV_OP_CAS_DESNOT] DEFAULT ('') FOR [CAS_DESNOT]
go
