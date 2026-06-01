/*  
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[U_OFF_TT] ADD 
	 ord_clifat varchar(10) COLLATE Latin1_General_CI_AS NULL,
	 ord_ragfat varchar(200) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_OFF_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_OFF_TT_ord_clifat] DEFAULT ('') FOR [ord_clifat],
	CONSTRAINT [DF_U_OFF_TT_ord_ragfat] DEFAULT ('') FOR [ord_ragfat]
go

UPDATE U_OFF_TT SET ord_clifat = ''
UPDATE U_OFF_TT SET ord_ragfat = ''

