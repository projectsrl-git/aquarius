/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[COMMESSA_TT] ADD 
	 TIPOOPERAZ varchar(3) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[COMMESSA_TT] WITH NOCHECK ADD 

	CONSTRAINT [DF_COMMESSA_TT_TIPOOPERAZ] DEFAULT ('') FOR [TIPOOPERAZ]
go

UPDATE COMMESSA_TT SET TIPOOPERAZ = ''



