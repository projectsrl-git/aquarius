
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_AMM_TT] ADD 
 	 ord_nregis varchar(10) COLLATE Latin1_General_CI_AS NULL,
 	 ord_dtreg varchar(10) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_AMM_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AMM_TT_ord_nregis]  DEFAULT ('   ') FOR [ord_nregis],
	CONSTRAINT [DF_U_AMM_TT_ord_dtreg]  DEFAULT ('   ') FOR [ord_dtreg]
go

UPDATE U_AMM_TT SET ord_nregis 	= '  '
UPDATE U_AMM_TT SET ord_dtreg 	= '  '





/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_AMM_TT] ADD 
 	 ord_codpri varchar(16) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_AMM_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AMM_TT_ord_codpri]  DEFAULT ('   ') FOR [ord_codpri]
go


UPDATE U_AMM_TT SET ord_codpri 	= '  '


/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_AMM_TT] ADD 
 	 ord_sysriga varchar(10) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_AMM_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AMM_TT_ord_sysriga]  DEFAULT ('   ') FOR [ord_sysriga]
go


UPDATE U_AMM_TT SET ord_sysriga 	= '  '


/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_AMM_TT] ADD 
 	 ord_dtutil varchar(10) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_AMM_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AMM_TT_ord_dtutil]  DEFAULT ('   ') FOR [ord_dtutil]
go


UPDATE U_AMM_TT SET ord_dtutil 	= '  '

/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_AMM_TT] ADD 
 	 ord_numpro varchar(13) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_AMM_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AMM_TT_ord_numpro]  DEFAULT ('   ') FOR [ord_numpro]
go


UPDATE U_AMM_TT SET ord_numpro 	= '  '




/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_AMM_TT] ADD 
 	  ord_nucesp numeric(10)  NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_AMM_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AMM_TT_ord_nucesp]  DEFAULT ('0') FOR [ord_nucesp]
go


UPDATE U_AMM_TT SET ord_nucesp 	= 0

