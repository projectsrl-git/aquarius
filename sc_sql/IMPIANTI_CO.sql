

/****** Object:  Table [dbo].[IMPIANTI_CO]   ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[IMPIANTI_CO]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[IMPIANTI_CO]
GO  
         
                

CREATE TABLE [dbo].[IMPIANTI_CO](
	[id_unique]  uniqueidentifier ROWGUIDCOL  NOT NULL CONSTRAINT [DF_IMPIANTI_CO_id_unique] DEFAULT (newid()),
	[GRUPPO]        	[varchar](30) NULL CONSTRAINT [DF_IMPIANTI_CO_GRUPPO] DEFAULT (''),
	[CCODSCHE]        	[varchar](20) NULL CONSTRAINT [DF_IMPIANTI_CO_CCODSCHE] DEFAULT (''),
	[ID_PMKEY]        	[varchar](10) NULL CONSTRAINT [DF_IMPIANTI_CO_ID_PMKEY] DEFAULT (''),            
	[ID_RIGO]         	[varchar](5) NULL CONSTRAINT [DF_IMPIANTI_CO_ID_RIGO] DEFAULT (''),            
	[TIPO_COMPONENTE]   [varchar](5) NULL CONSTRAINT [DF_IMPIANTI_CO_TIPO_COMPONENTE] DEFAULT (''),            
	[CDITTACAL]      	[varchar](50) NULL CONSTRAINT [DF_IMPIANTI_CO_CDITTACAL] DEFAULT (''), 
	[CMODCAL]      		[varchar](25) NULL CONSTRAINT [DF_IMPIANTI_CO_CMODCAL] DEFAULT (''), 
	[CMATCAL]			[varchar](40) NULL CONSTRAINT [DF_IMPIANTI_CO_CMATCAL] DEFAULT (''), 
	[ID_PMCONTR]      	[varchar](10) NULL CONSTRAINT [DF_IMPIANTI_CO_ID_PMCONTR] DEFAULT (''), 
	[ANNO_CONTR]      	[varchar](4) NULL CONSTRAINT [DF_IMPIANTI_CO_OANNO_CONTR] DEFAULT (''), 
	[CONTRATTO]       	[varchar](30) NULL CONSTRAINT [DF_IMPIANTI_CO_CONTRATTO] DEFAULT (''), 
	[DT_REGIST]       	[varchar](10) NULL CONSTRAINT [DF_IMPIANTI_CO_DT_REGIST] DEFAULT (''), 
	[ORA_REGIST]      	[varchar](8) NULL CONSTRAINT [DF_IMPIANTI_CO_ORA_REGIST] DEFAULT (''), 
	[CINIZCONTR]      	[varchar](10) NULL CONSTRAINT [DF_IMPIANTI_CO_CINIZCONTR] DEFAULT (''), 
	[CSCADCONTR]      	[varchar](10) NULL CONSTRAINT [DF_IMPIANTI_CO_CSCADCONTR] DEFAULT (''), 
	[DT_CONFERM]      	[varchar](10) NULL CONSTRAINT [DF_IMPIANTI_CO_DT_CONFERM] DEFAULT (''), 
	[DT_DISDETT]      	[varchar](10) NULL CONSTRAINT [DF_IMPIANTI_CO_DT_DISDETT] DEFAULT (''), 
	[DT_INIZIO]       	[varchar](10) NULL CONSTRAINT [DF_IMPIANTI_CO_DT_INIZIO] DEFAULT (''), 
	[DT_FINE]         	[varchar](10) NULL CONSTRAINT [DF_IMPIANTI_CO_DT_FINE] DEFAULT (''), 
	[CONTR_A]        	[varchar](3) NULL CONSTRAINT [DF_IMPIANTI_CO_CONTR_A] DEFAULT (''),            
	[CONTR_B]        	[varchar](3) NULL CONSTRAINT [DF_IMPIANTI_CO_CONTR_B] DEFAULT (''),            
	[CONTR_C]        	[varchar](3) NULL CONSTRAINT [DF_IMPIANTI_CO_CONTR_C] DEFAULT (''),            
	[CONTR_D1]        	[varchar](3) NULL CONSTRAINT [DF_IMPIANTI_CO_CONTR_D1] DEFAULT (''),            
	[CONTR_D2]        	[varchar](3) NULL CONSTRAINT [DF_IMPIANTI_CO_CONTR_D2] DEFAULT (''),            
	[CONTR_E1]        	[varchar](3) NULL CONSTRAINT [DF_IMPIANTI_CO_CONTR_E1] DEFAULT (''),            
	[CONTR_E2]        	[varchar](3) NULL CONSTRAINT [DF_IMPIANTI_CO_CONTR_E2] DEFAULT (''),            
	[CONTR_F1]        	[varchar](3) NULL CONSTRAINT [DF_IMPIANTI_CO_CONTR_F1] DEFAULT (''),            
	[CONTR_F2]        	[varchar](3) NULL CONSTRAINT [DF_IMPIANTI_CO_CONTR_F2] DEFAULT (''),            
	[CA]      			[varchar](1) NULL CONSTRAINT [DF_IMPIANTI_CO_CA] DEFAULT (''), 
	[CB]      			[varchar](1) NULL CONSTRAINT [DF_IMPIANTI_CO_CB] DEFAULT (''), 
	[CC]      			[varchar](1) NULL CONSTRAINT [DF_IMPIANTI_CO_CC] DEFAULT (''), 
	[CD1]      			[varchar](1) NULL CONSTRAINT [DF_IMPIANTI_CO_CD1] DEFAULT (''), 
	[CD2]      			[varchar](1) NULL CONSTRAINT [DF_IMPIANTI_CO_CD2] DEFAULT (''), 
	[CE1]      			[varchar](1) NULL CONSTRAINT [DF_IMPIANTI_CO_CE1] DEFAULT (''), 
	[CE2]      			[varchar](1) NULL CONSTRAINT [DF_IMPIANTI_CO_CE2] DEFAULT (''), 
	[CF1]      			[varchar](1) NULL CONSTRAINT [DF_IMPIANTI_CO_CF1] DEFAULT (''), 
	[CF2]      			[varchar](1) NULL CONSTRAINT [DF_IMPIANTI_CO_CF2] DEFAULT (''), 
	[CQTA_A]      		[varchar](3) NULL CONSTRAINT [DF_IMPIANTI_CO_CQTA_A] DEFAULT (''), 
	[CQTA_B]      		[varchar](3) NULL CONSTRAINT [DF_IMPIANTI_CO_CQTA_B] DEFAULT (''), 
	[CQTA_C]      		[varchar](3) NULL CONSTRAINT [DF_IMPIANTI_CO_CQTA_C] DEFAULT (''), 
	[CQTA_D1]      		[varchar](3) NULL CONSTRAINT [DF_IMPIANTI_CO_CQTA_D1] DEFAULT (''), 
	[CQTA_D2]      		[varchar](3) NULL CONSTRAINT [DF_IMPIANTI_CO_CQTA_D2] DEFAULT (''), 
	[CQTA_E1]      		[varchar](3) NULL CONSTRAINT [DF_IMPIANTI_CO_CQTA_E1] DEFAULT (''), 
	[CQTA_E2]      		[varchar](3) NULL CONSTRAINT [DF_IMPIANTI_CO_CQTA_E2] DEFAULT (''), 
	[CQTA_F1]      		[varchar](3) NULL CONSTRAINT [DF_IMPIANTI_CO_CQTA_F1] DEFAULT (''), 
	[CQTA_F2]      		[varchar](3) NULL CONSTRAINT [DF_IMPIANTI_CO_CQTA_F2] DEFAULT (''), 
	[CCOSTOA]         	[Numeric](19,5) NULL,       
	[CCOSTOB]         	[Numeric](19,5) NULL,       
	[CCOSTOC]         	[Numeric](19,5) NULL,       
	[CCOSTOD1]         	[Numeric](19,5) NULL,       
	[CCOSTOD2]         	[Numeric](19,5) NULL,       
	[CCOSTOE1]         	[Numeric](19,5) NULL,       
	[CCOSTOE2]        	[Numeric](19,5) NULL,       
	[CCOSTOF1]         	[Numeric](19,5) NULL,       
	[CCOSTOF2]         	[Numeric](19,5) NULL,     
	[CSCAD_A]        	[varchar](8) NULL CONSTRAINT [DF_IMPIANTI_CO_CSCAD_A] DEFAULT (''),            
	[CSCAD_B]        	[varchar](8) NULL CONSTRAINT [DF_IMPIANTI_CO_CSCAD_B] DEFAULT (''),            
	[CSCAD_C]        	[varchar](8) NULL CONSTRAINT [DF_IMPIANTI_CO_CSCAD_C] DEFAULT (''),            
	[CSCAD_D1]        	[varchar](8) NULL CONSTRAINT [DF_IMPIANTI_CO_CSCAD_D1] DEFAULT (''),            
	[CSCAD_D2]        	[varchar](8) NULL CONSTRAINT [DF_IMPIANTI_CO_CSCAD_D2] DEFAULT (''),            
	[CSCAD_E1]        	[varchar](8) NULL CONSTRAINT [DF_IMPIANTI_CO_CSCAD_E1] DEFAULT (''),            
	[CSCAD_E2]        	[varchar](8) NULL CONSTRAINT [DF_IMPIANTI_CO_CSCAD_E2] DEFAULT (''),            
	[CSCAD_F1]        	[varchar](8) NULL CONSTRAINT [DF_IMPIANTI_CO_CSCAD_F1] DEFAULT (''),            
	[CSCAD_F2]        	[varchar](8) NULL CONSTRAINT [DF_IMPIANTI_CO_CSCAD_F2] DEFAULT (''),
	[CNOTECONTR]      	[varchar](254) NULL CONSTRAINT [DF_IMPIANTI_CO_CNOTECONTR] DEFAULT (''), 
	[TIPO_STAG]      	[varchar](3) NULL CONSTRAINT [DF_IMPIANTI_CO_TIPO_STAG] DEFAULT (''),
	[CRINNOVARE]	  	[bit] NULL           
) 

ALTER TABLE [dbo].[IMPIANTI_CO] WITH NOCHECK ADD 
	CONSTRAINT [PK_IMPIANTI_CO] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO
