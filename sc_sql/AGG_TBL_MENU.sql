/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[TBL_MENU] ADD 
	 SELEZIONE varchar(10) COLLATE Latin1_General_CI_AS NULL

go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[TBL_MENU] WITH NOCHECK ADD 
	CONSTRAINT [DF_TBL_MENU_SELEZIONE] DEFAULT ('   ') FOR [SELEZIONE]
go



UPDATE TBL_MENU SET SELEZIONE 	= '   '


/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[TBL_MENU] ADD 
	 tbl_oper varchar(20) COLLATE Latin1_General_CI_AS NULL

go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[TBL_MENU] WITH NOCHECK ADD 
	CONSTRAINT [DF_TBL_tbl_oper] DEFAULT ('   ') FOR [tbl_oper]
go



UPDATE TBL_MENU SET tbl_oper 	= '   '
