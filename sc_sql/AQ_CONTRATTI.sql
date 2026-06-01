

/****** Object:  Table [dbo].[AQ_CONTRATTI]   ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[AQ_CONTRATTI]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[AQ_CONTRATTI]
GO  
                    

CREATE TABLE [dbo].[AQ_CONTRATTI](
	[id_unique]  uniqueidentifier ROWGUIDCOL  NOT NULL CONSTRAINT [DF_AQ_CONTRATTI_id_unique] DEFAULT (newid()),
	[ID_PMKEY]        [varchar](10) NULL CONSTRAINT [DF_AQ_CONTRATTI_ID_PMKEY] DEFAULT (''),            
	[CCODSCHE]        [varchar](20) NULL CONSTRAINT [DF_AQ_CONTRATTI_CCODSCHE] DEFAULT (''),
	[ID_RIGO]         [varchar](5) NULL CONSTRAINT [DF_AQ_CONTRATTI_ID_RIGO] DEFAULT (''), 
	[ID_PMCONTR]      [varchar](10) NULL CONSTRAINT [DF_AQ_CONTRATTI_ID_PMCONTR] DEFAULT (''), 
	[CONTR_A]         [varchar](3) NULL CONSTRAINT [DF_AQ_CONTRATTI_CONTR_A] DEFAULT (''), 
	[CONTR_B]         [varchar](3) NULL CONSTRAINT [DF_AQ_CONTRATTI_CONTR_B] DEFAULT (''), 
	[CONTR_C]         [varchar](3) NULL CONSTRAINT [DF_AQ_CONTRATTI_CONTR_C] DEFAULT (''), 
	[CONTR_D1]        [varchar](3) NULL CONSTRAINT [DF_AQ_CONTRATTI_CONTR_D1] DEFAULT (''),
	[CONTR_D2]        [varchar](3) NULL CONSTRAINT [DF_AQ_CONTRATTI_CONTR_D2] DEFAULT (''), 
	[CONTR_E1]        [varchar](3) NULL CONSTRAINT [DF_AQ_CONTRATTI_CONTR_E1] DEFAULT (''), 
	[CONTR_E2]        [varchar](3) NULL CONSTRAINT [DF_AQ_CONTRATTI_CONTR_E2] DEFAULT (''),
	[CONTR_F1]        [varchar](3) NULL CONSTRAINT [DF_AQ_CONTRATTI_CONTR_F1] DEFAULT (''),
	[CA]              [varchar](1) NULL CONSTRAINT [DF_AQ_CONTRATTI_CA] DEFAULT (''),
	[CB]              [varchar](1) NULL CONSTRAINT [DF_AQ_CONTRATTI_CB] DEFAULT (''), 
	[CC]              [varchar](1) NULL CONSTRAINT [DF_AQ_CONTRATTI_CC] DEFAULT (''), 
	[CD1]             [varchar](1) NULL CONSTRAINT [DF_AQ_CONTRATTI_CD1] DEFAULT (''), 
	[CD2]             [varchar](1) NULL CONSTRAINT [DF_AQ_CONTRATTI_CD2] DEFAULT (''), 
	[CE1]             [varchar](1) NULL CONSTRAINT [DF_AQ_CONTRATTI_CE1] DEFAULT (''), 
	[CE2]             [varchar](1) NULL CONSTRAINT [DF_AQ_CONTRATTI_CE2] DEFAULT (''),
	[CF1]             [varchar](1) NULL CONSTRAINT [DF_AQ_CONTRATTI_CF1] DEFAULT (''),
	[CF2]             [varchar](1) NULL CONSTRAINT [DF_AQ_CONTRATTI_CF2] DEFAULT (''), 
	[CQTA_A]         [Numeric](10) NULL, 
	[CQTA_B]         [Numeric](10) NULL, 
	[CQTA_C]         [Numeric](10) NULL, 
	[CQTA_D1]         [Numeric](10) NULL, 
	[CQTA_D2]         [Numeric](10) NULL, 
	[CQTA_E1]         [Numeric](10) NULL, 
	[CQTA_E2]         [Numeric](10) NULL, 
	[CQTA_F1]         [Numeric](10) NULL, 
	[CQTA_F2]         [Numeric](10) NULL, 
	[CCOSTOA]        [Numeric](19,5) NULL,       
	[CCOSTOB]        [Numeric](19,5) NULL,       
	[CCOSTOC]        [Numeric](19,5) NULL,       
	[CCOSTOD1]        [Numeric](19,5) NULL,       
	[CCOSTOD2]        [Numeric](19,5) NULL,       
	[CCOSTOE1]        [Numeric](19,5) NULL,       
	[CCOSTOE2]        [Numeric](19,5) NULL,       
	[CCOSTOF1]        [Numeric](19,5) NULL,       
	[CCOSTOF2]        [Numeric](19,5) NULL,       
	[CSCAD_A]         [varchar](10) NULL CONSTRAINT [DF_AQ_CONTRATTI_CSCAD_A] DEFAULT (''), 
	[CSCAD_B]         [varchar](10) NULL CONSTRAINT [DF_AQ_CONTRATTI_CSCAD_B] DEFAULT (''), 
	[CSCAD_C]         [varchar](10) NULL CONSTRAINT [DF_AQ_CONTRATTI_CSCAD_C] DEFAULT (''), 
	[CSCAD_D1]        [varchar](10) NULL CONSTRAINT [DF_AQ_CONTRATTI_CSCAD_D1] DEFAULT (''), 
	[CSCAD_D2]        [varchar](10) NULL CONSTRAINT [DF_AQ_CONTRATTI_CSCAD_D2] DEFAULT (''), 
	[CSCAD_E1]        [varchar](10) NULL CONSTRAINT [DF_AQ_CONTRATTI_CSCAD_E1] DEFAULT (''), 
	[CSCAD_E2]        [varchar](10) NULL CONSTRAINT [DF_AQ_CONTRATTI_CSCAD_E2] DEFAULT (''), 
	[CSCAD_F1]        [varchar](10) NULL CONSTRAINT [DF_AQ_CONTRATTI_CSCAD_F1] DEFAULT (''), 
	[CSCAD_F2]        [varchar](10) NULL CONSTRAINT [DF_AQ_CONTRATTI_CSCAD_F2] DEFAULT ('')
) 

ALTER TABLE [dbo].[AQ_CONTRATTI] WITH NOCHECK ADD 
	CONSTRAINT [PK_AQ_CONTRATTI] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO


