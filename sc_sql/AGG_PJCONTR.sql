
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[PJ_CON_TR] ADD 
	 CON_BFOTRA [numeric](10) NULL ,
	 CON_BFORIC [numeric](10) NULL ,
	 CON_AUTTRA [numeric](10) NULL ,
	 CON_AUTRIC [numeric](10) NULL ,
	 CON_PNCTRA [numeric](10) NULL ,
	 CON_PNCRIC [numeric](10) NULL ,
	 CON_PNSTRA [numeric](10) NULL ,
	 CON_PNSRIC [numeric](10) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[PJ_CON_TR] WITH NOCHECK ADD 
	CONSTRAINT [DF_PJ_CON_TR_CON_BFOTRA] DEFAULT (0) FOR [CON_BFOTRA],
	CONSTRAINT [DF_PJ_CON_TR_CON_BFORIC] DEFAULT (0) FOR [CON_BFORIC],
	CONSTRAINT [DF_PJ_CON_TR_CON_AUTTRA] DEFAULT (0) FOR [CON_AUTTRA],
	CONSTRAINT [DF_PJ_CON_TR_CON_AUTRIC] DEFAULT (0) FOR [CON_AUTRIC],
	CONSTRAINT [DF_PJ_CON_TR_CON_PNCTRA] DEFAULT (0) FOR [CON_PNCTRA],
	CONSTRAINT [DF_PJ_CON_TR_CON_PNCRIC] DEFAULT (0) FOR [CON_PNCRIC],
	CONSTRAINT [DF_PJ_CON_TR_CON_PNSTRA] DEFAULT (0) FOR [CON_PNSTRA],
	CONSTRAINT [DF_PJ_CON_TR_CON_PNSRIC] DEFAULT (0) FOR [CON_PNSRIC]
go
