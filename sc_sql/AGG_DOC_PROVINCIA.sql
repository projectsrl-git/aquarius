
/* 
**************************************************************
INSERIMENTO DEL/I NUOVO CAMPO PROVINCIA SUI DOCUMENTI
**************************************************************
*/
ALTER TABLE [dbo].[U_OFF_TT] ADD 
	 ORD_PROVIN varchar(2) COLLATE Latin1_General_CI_AS NULL ,
	 ORD_PROC varchar(2) COLLATE Latin1_General_CI_AS NULL
go
ALTER TABLE [dbo].[U_OFF_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_OFF_TT_ORD_PROVIN] DEFAULT ('') FOR [ORD_PROVIN],
	CONSTRAINT [DF_U_OFF_TT_ORD_PROC] DEFAULT ('') FOR [ORD_PROC]
go
/*
**************************************************************
*/
ALTER TABLE [dbo].[U_ORD_TT] ADD 
	 ORD_PROVIN varchar(2) COLLATE Latin1_General_CI_AS NULL ,
	 ORD_PROC varchar(2) COLLATE Latin1_General_CI_AS NULL
go
ALTER TABLE [dbo].[U_ORD_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_ORD_TT_ORD_PROVIN] DEFAULT ('') FOR [ORD_PROVIN],
	CONSTRAINT [DF_U_ORD_TT_ORD_PROC] DEFAULT ('') FOR [ORD_PROC]
go
/*
**************************************************************
*/
ALTER TABLE [dbo].[U_MRI_TT] ADD 
	 ORD_PROVIN varchar(2) COLLATE Latin1_General_CI_AS NULL ,
	 ORD_PROC varchar(2) COLLATE Latin1_General_CI_AS NULL
go
ALTER TABLE [dbo].[U_MRI_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_MRI_TT_ORD_PROVIN] DEFAULT ('') FOR [ORD_PROVIN],
	CONSTRAINT [DF_U_MRI_TT_ORD_PROC] DEFAULT ('') FOR [ORD_PROC]
go
/*
**************************************************************
*/
ALTER TABLE [dbo].[U_BOL_TT] ADD 
	 ORD_PROVIN varchar(2) COLLATE Latin1_General_CI_AS NULL ,
	 ORD_PROC varchar(2) COLLATE Latin1_General_CI_AS NULL
go
ALTER TABLE [dbo].[U_BOL_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_BOL_TT_ORD_PROVIN] DEFAULT ('') FOR [ORD_PROVIN],
	CONSTRAINT [DF_U_BOL_TT_ORD_PROC] DEFAULT ('') FOR [ORD_PROC]
go
/*
**************************************************************
*/
ALTER TABLE [dbo].[U_SPE_TT] ADD 
	 ORD_PROVIN varchar(2) COLLATE Latin1_General_CI_AS NULL ,
	 ORD_PROC varchar(2) COLLATE Latin1_General_CI_AS NULL
go
ALTER TABLE [dbo].[U_SPE_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_SPE_TT_ORD_PROVIN] DEFAULT ('') FOR [ORD_PROVIN],
	CONSTRAINT [DF_U_SPE_TT_ORD_PROC] DEFAULT ('') FOR [ORD_PROC]
go
/*
**************************************************************
*/
ALTER TABLE [dbo].[U_BFO_TT] ADD 
	 ORD_PROVIN varchar(2) COLLATE Latin1_General_CI_AS NULL
go
ALTER TABLE [dbo].[U_BFO_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_BFO_TT_ORD_PROVIN] DEFAULT ('') FOR [ORD_PROVIN]
go
/*
**************************************************************
*/
ALTER TABLE [dbo].[U_FAP_TT] ADD 
	 ORD_PROVIN varchar(2) COLLATE Latin1_General_CI_AS NULL
go
ALTER TABLE [dbo].[U_FAP_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_FAP_TT_ORD_PROVIN] DEFAULT ('') FOR [ORD_PROVIN]
go
/*
**************************************************************
*/
ALTER TABLE [dbo].[U_FAT_TT] ADD 
	 ORD_PROVIN varchar(2) COLLATE Latin1_General_CI_AS NULL
go
ALTER TABLE [dbo].[U_FAT_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_FAT_TT_ORD_PROVIN] DEFAULT ('') FOR [ORD_PROVIN]
go
/*
**************************************************************
*/
ALTER TABLE [dbo].[U_ORF_TT] ADD 
	 ORD_PROVIN varchar(2) COLLATE Latin1_General_CI_AS NULL ,
	 ORD_PROC varchar(2) COLLATE Latin1_General_CI_AS NULL
go
ALTER TABLE [dbo].[U_ORF_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_ORF_TT_ORD_PROVIN] DEFAULT ('') FOR [ORD_PROVIN],
	CONSTRAINT [DF_U_ORF_TT_ORD_PROC] DEFAULT ('') FOR [ORD_PROC]
go
/*
**************************************************************
*/
ALTER TABLE [dbo].[U_CTL_TT] ADD 
	 ORD_PROVIN varchar(2) COLLATE Latin1_General_CI_AS NULL ,
	 ORD_PROC varchar(2) COLLATE Latin1_General_CI_AS NULL
go
ALTER TABLE [dbo].[U_CTL_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_CTL_TT_ORD_PROVIN] DEFAULT ('') FOR [ORD_PROVIN],
	CONSTRAINT [DF_U_CTL_TT_ORD_PROC] DEFAULT ('') FOR [ORD_PROC]
go
/*
**************************************************************
*/
ALTER TABLE [dbo].[U_CEI_TT] ADD 
	 ORD_PROVIN varchar(2) COLLATE Latin1_General_CI_AS NULL
go
ALTER TABLE [dbo].[U_CEI_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_CEI_TT_ORD_PROVIN] DEFAULT ('') FOR [ORD_PROVIN]
go
/*
**************************************************************
*/
ALTER TABLE [dbo].[U_CEA_TT] ADD 
	 ORD_PROVIN varchar(2) COLLATE Latin1_General_CI_AS NULL
go
ALTER TABLE [dbo].[U_CEA_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_CEA_TT_ORD_PROVIN] DEFAULT ('') FOR [ORD_PROVIN]
go
/*
**************************************************************
*/
ALTER TABLE [dbo].[U_RIA_TT] ADD 
	 ORD_PROVIN varchar(2) COLLATE Latin1_General_CI_AS NULL
go
ALTER TABLE [dbo].[U_RIA_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_RIA_TT_ORD_PROVIN] DEFAULT ('') FOR [ORD_PROVIN]
go
/*
**************************************************************
*/
ALTER TABLE [dbo].[U_RAA_TT] ADD 
	 ORD_PROVIN varchar(2) COLLATE Latin1_General_CI_AS NULL
go
ALTER TABLE [dbo].[U_RAA_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_RAA_TT_ORD_PROVIN] DEFAULT ('') FOR [ORD_PROVIN]
go
/*
**************************************************************
*/
ALTER TABLE [dbo].[U_FAM_TT] ADD 
	 ORD_PROVIN varchar(2) COLLATE Latin1_General_CI_AS NULL
go
ALTER TABLE [dbo].[U_FAM_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_FAM_TT_ORD_PROVIN] DEFAULT ('') FOR [ORD_PROVIN]
go
/*
**************************************************************
*/
ALTER TABLE [dbo].[U_AMM_TT] ADD 
	 ORD_PROVIN varchar(2) COLLATE Latin1_General_CI_AS NULL
go
ALTER TABLE [dbo].[U_AMM_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AMM_TT_ORD_PROVIN] DEFAULT ('') FOR [ORD_PROVIN]
go
