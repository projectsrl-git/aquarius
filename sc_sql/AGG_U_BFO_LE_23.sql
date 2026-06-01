
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/


ALTER TABLE [dbo].[U_BFO_LE] ADD 
	 LEG_CONDET varchar(13) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_BFO_LE] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_BFO_LE_LEG_CONDET] DEFAULT ('') FOR [LEG_CONDET]
go

UPDATE U_BFO_LE SET LEG_CONDET = ''









