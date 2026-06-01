/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_CEA_DD] ADD 
	 	 ORD_PAEPRO varchar(2) COLLATE Latin1_General_CI_AS NULL
 
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_CEA_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_CEA_DD_ORD_PAEPRO] DEFAULT (' ') FOR [ORD_PAEPRO]
go

UPDATE U_CEA_DD SET ORD_PAEPRO = '  '


