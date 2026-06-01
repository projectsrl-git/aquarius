
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[BUDGET_CONS] ADD 
		ORD_CONDET varchar (13) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[BUDGET_CONS] WITH NOCHECK ADD 
        CONSTRAINT [DF_BUDGET_CONS_ORD_CONDET] DEFAULT ('') FOR [ORD_CONDET]
go



UPDATE BUDGET_CONS SET ORD_CONDET 	= ''



/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[BUDGET_CONS] ADD 
	 ord_ccodet varchar(13) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[BUDGET_CONS] WITH NOCHECK ADD 
	CONSTRAINT [DF_BUDGET_CONS_ord_ccodet] DEFAULT ('') FOR [ord_ccodet]
go

UPDATE BUDGET_CONS SET ord_ccodet = ''


