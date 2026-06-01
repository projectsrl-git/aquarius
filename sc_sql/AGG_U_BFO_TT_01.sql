/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_BFO_TT] ADD 
	 	 ORD_CODACQ varchar(03) COLLATE Latin1_General_CI_AS NULL,
	 	 ORD_DESACQ varchar(30) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[U_BFO_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_BFO_TT_ORD_CODACQ] DEFAULT ('    ') FOR [ORD_CODACQ],
	CONSTRAINT [DF_U_BFO_TT_ORD_DESACQ] DEFAULT ('    ') FOR [ORD_DESACQ]
go



UPDATE U_BFO_TT SET ORD_CODACQ 	= ' '
UPDATE U_BFO_TT SET ORD_DESACQ 	= '          ' 

