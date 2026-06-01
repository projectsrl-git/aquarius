
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_ORD_TT] ADD 
	 ORD_TPORDI varchar(01) COLLATE Latin1_General_CI_AS NULL,
	 ORD_DSORDI varchar(30) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_ORD_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_ORD_TT_ORD_TPORDI] DEFAULT ('') FOR [ORD_TPORDI],
	CONSTRAINT [DF_U_ORD_TT_ORD_DSORDI] DEFAULT ('') FOR [ORD_DSORDI]
go

UPDATE U_ORD_TT SET ORD_TPORDI = SPACE(01)
UPDATE U_ORD_TT SET ORD_DSORDI = SPACE(30)
