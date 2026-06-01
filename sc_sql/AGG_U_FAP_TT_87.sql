/*    
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[U_FAP_TT] ADD 
	 ord_proc varchar(02) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_FAP_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_FAP_TT_ord_proc] DEFAULT ('') FOR [ord_proc]
go

UPDATE U_FAP_TT SET ord_proc = ''
