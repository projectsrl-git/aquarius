
/* 
**********************************************************************************************
INSERIMENTO CAMPO "CUP" IN TESTATE DOCUMENTI
**********************************************************************************************
*/


ALTER TABLE [dbo].[U_OFF_TT] ADD 
	 ORD_CUP [varchar] (15) COLLATE Latin1_General_CI_AS NULL

go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_OFF_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_OFF_TT_ORD_CUP] DEFAULT ('') FOR [ORD_CUP]
go

UPDATE U_OFF_TT SET ORD_CUP = ''




ALTER TABLE [dbo].[U_ORD_TT] ADD 
	 ORD_CUP [varchar] (15) COLLATE Latin1_General_CI_AS NULL

go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_ORD_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_ORD_TT_ORD_CUP] DEFAULT ('') FOR [ORD_CUP]
go

UPDATE U_ORD_TT SET ORD_CUP = ''




ALTER TABLE [dbo].[U_BOL_TT] ADD 
	 ORD_CUP [varchar] (15) COLLATE Latin1_General_CI_AS NULL

go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_BOL_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_BOL_TT_ORD_CUP] DEFAULT ('') FOR [ORD_CUP]
go

UPDATE U_BOL_TT SET ORD_CUP = ''


ALTER TABLE [dbo].[L_BOL_TT] ADD 
	 ORD_CUP [varchar] (15) COLLATE Latin1_General_CI_AS NULL

go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[L_BOL_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_L_BOL_TT_ORD_CUP] DEFAULT ('') FOR [ORD_CUP]
go

UPDATE L_BOL_TT SET ORD_CUP = ''



ALTER TABLE [dbo].[U_FAP_TT] ADD 
	 ORD_CUP [varchar] (15) COLLATE Latin1_General_CI_AS NULL

go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_FAP_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_FAP_TT_ORD_CUP] DEFAULT ('') FOR [ORD_CUP]
go

UPDATE U_FAP_TT SET ORD_CUP = ''




ALTER TABLE [dbo].[U_FAT_TT] ADD 
	 ORD_CUP [varchar] (15) COLLATE Latin1_General_CI_AS NULL

go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_FAT_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_FAT_TT_ORD_CUP] DEFAULT ('') FOR [ORD_CUP]
go

UPDATE U_FAT_TT SET ORD_CUP = ''




/* 
**********************************************************************************************
INSERIMENTO CAMPO "CIG" IN TESTATE DOCUMENTI
**********************************************************************************************
*/


ALTER TABLE [dbo].[U_OFF_TT] ADD 
	 ORD_CIG [varchar] (10) COLLATE Latin1_General_CI_AS NULL

go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_OFF_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_OFF_TT_ORD_CIG] DEFAULT ('') FOR [ORD_CIG]
go

UPDATE U_OFF_TT SET ORD_CIG = ''




ALTER TABLE [dbo].[U_ORD_TT] ADD 
	 ORD_CIG [varchar] (10) COLLATE Latin1_General_CI_AS NULL

go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_ORD_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_ORD_TT_ORD_CIG] DEFAULT ('') FOR [ORD_CIG]
go

UPDATE U_ORD_TT SET ORD_CIG = ''




ALTER TABLE [dbo].[U_BOL_TT] ADD 
	 ORD_CIG [varchar] (10) COLLATE Latin1_General_CI_AS NULL

go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_BOL_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_BOL_TT_ORD_CIG] DEFAULT ('') FOR [ORD_CIG]
go

UPDATE U_BOL_TT SET ORD_CIG = ''


ALTER TABLE [dbo].[L_BOL_TT] ADD 
	 ORD_CIG [varchar] (10) COLLATE Latin1_General_CI_AS NULL

go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[L_BOL_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_L_BOL_TT_ORD_CIG] DEFAULT ('') FOR [ORD_CIG]
go

UPDATE L_BOL_TT SET ORD_CIG = ''



ALTER TABLE [dbo].[U_FAP_TT] ADD 
	 ORD_CIG [varchar] (10) COLLATE Latin1_General_CI_AS NULL

go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_FAP_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_FAP_TT_ORD_CIG] DEFAULT ('') FOR [ORD_CIG]
go

UPDATE U_FAP_TT SET ORD_CIG = ''




ALTER TABLE [dbo].[U_FAT_TT] ADD 
	 ORD_CIG [varchar] (10) COLLATE Latin1_General_CI_AS NULL

go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_FAT_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_FAT_TT_ORD_CIG] DEFAULT ('') FOR [ORD_CIG]
go

UPDATE U_FAT_TT SET ORD_CIG = ''



