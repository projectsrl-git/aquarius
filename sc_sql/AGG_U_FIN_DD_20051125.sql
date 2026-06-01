
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_FIN_DD] ADD 
	 	 FIN_CONTROP varchar(10) COLLATE Latin1_General_CI_AS NULL,
	 	 FIN_DESCONP varchar(10) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_FIN_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_FIN_DD_FIN_CONTROP] DEFAULT ('') FOR [FIN_CONTROP],
	CONSTRAINT [DF_U_FIN_DD_FIN_DESCONP] DEFAULT ('') FOR [FIN_DESCONP]
go

UPDATE U_FIN_DD SET FIN_CONTROP 	= ''
UPDATE U_FIN_DD SET FIN_DESCONP 	= ''

