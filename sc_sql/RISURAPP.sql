if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[RisURapp]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[RisURapp]
GO

CREATE TABLE [dbo].[RisURapp] (
	[id_unique]  uniqueidentifier ROWGUIDCOL  NOT NULL ,
	[DAGGANCIO] [varchar] (32) COLLATE Latin1_General_CI_AS NULL ,
	[ID_RAPPORTO] [varchar] (32) COLLATE Latin1_General_CI_AS NULL ,
	[TipoRapp] [varchar] (32) COLLATE Latin1_General_CI_AS NULL ,
	[StatoRap] [varchar] (32) COLLATE Latin1_General_CI_AS NULL ,
	[D_Data] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[D_Inizio] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[D_Fine] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[B_InCorso] [varchar] (1) COLLATE Latin1_General_CI_AS NULL ,
	[Durata] [varchar] (150) COLLATE Latin1_General_CI_AS NULL ,
	[ProvaGG] [numeric](3, 0) NULL ,
	[ImportoBase] [numeric](17, 2) NULL ,
	[RifImporto] [numeric](3, 0) NULL ,
	[Livello] [varchar] (100) COLLATE Latin1_General_CI_AS NULL ,
	[EDR] [varchar] (100) COLLATE Latin1_General_CI_AS NULL ,
	[CodiceContr] [varchar] (25) COLLATE Latin1_General_CI_AS NULL ,
	[DocContratt] [text] COLLATE Latin1_General_CI_AS NULL ,
	[ORDINE] [numeric](3, 0) NULL ,
	[IDANAAZIEST] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[ANAAZIEST] [varchar] (80) COLLATE Latin1_General_CI_AS NULL ,
	[IDANAAZIGRP] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[ANAAZIGRP] [varchar] (80) COLLATE Latin1_General_CI_AS NULL ,
	[TIPO_RISORSA] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[TIPO_ATTIVITA] [varchar] (200) COLLATE Latin1_General_CI_AS NULL ,
	[MATRICOLA] [varchar] (5) COLLATE Latin1_General_CI_AS NULL ,
	[CENTRCOM] [varchar] (5) COLLATE Latin1_General_CI_AS NULL ,
	[IMPORTOLETTERE] [varchar] (150) COLLATE Latin1_General_CI_AS NULL ,
	[DURATA_EFF] [varchar] (150) COLLATE Latin1_General_CI_AS NULL ,
	[UMPROVA] [varchar] (2) COLLATE Latin1_General_CI_AS NULL ,
	[D_FINE_EFF] [varchar] (150) COLLATE Latin1_General_CI_AS NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[RisURapp] WITH NOCHECK ADD 
	CONSTRAINT [PK_RisURapp] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[RisURapp] WITH NOCHECK ADD 
	CONSTRAINT [DF_RisURapp_id_unique] DEFAULT (newid()) FOR [id_unique],
	CONSTRAINT [DF_RisURapp_DAGGANCIO] DEFAULT ('') FOR [DAGGANCIO],
	CONSTRAINT [DF_RisURapp_ID_RAPPORTO] DEFAULT ('') FOR [ID_RAPPORTO],
	CONSTRAINT [DF_RisURapp_TipoRapp] DEFAULT ('') FOR [TipoRapp],
	CONSTRAINT [DF_RisURapp_StatoRap] DEFAULT ('') FOR [StatoRap],
	CONSTRAINT [DF_RisURapp_D_Data] DEFAULT ('') FOR [D_Data],
	CONSTRAINT [DF_RisURapp_D_Inizio] DEFAULT ('') FOR [D_Inizio],
	CONSTRAINT [DF_RisURapp_D_Fine] DEFAULT ('') FOR [D_Fine],
	CONSTRAINT [DF_RisURapp_B_InCorso] DEFAULT ('') FOR [B_InCorso],
	CONSTRAINT [DF_RisURapp_Durata] DEFAULT ('') FOR [Durata],
	CONSTRAINT [DF_RisURapp_ProvaGG] DEFAULT (0) FOR [ProvaGG],
	CONSTRAINT [DF_RisURapp_ImportoBase] DEFAULT (0) FOR [ImportoBase],
	CONSTRAINT [DF_RisURapp_RifImporto] DEFAULT (0) FOR [RifImporto],
	CONSTRAINT [DF_RisURapp_Livello] DEFAULT ('') FOR [Livello],
	CONSTRAINT [DF_RisURapp_EDR] DEFAULT ('') FOR [EDR],
	CONSTRAINT [DF_RisURapp_CodiceContr] DEFAULT ('') FOR [CodiceContr],
	CONSTRAINT [DF_RisURapp_DocContratt] DEFAULT ('') FOR [DocContratt],
	CONSTRAINT [DF_RisURapp_ORDINE] DEFAULT (0) FOR [ORDINE],
	CONSTRAINT [DF_RISURAPP_IDANAAZIEST] DEFAULT ('') FOR [IDANAAZIEST],
	CONSTRAINT [DF_RISURAPP_ANAAZIEST] DEFAULT ('') FOR [ANAAZIEST],
	CONSTRAINT [DF_RISURAPP_IDANAAZIGRP] DEFAULT ('') FOR [IDANAAZIGRP],
	CONSTRAINT [DF_RISURAPP_ANAAZIGRP] DEFAULT ('') FOR [ANAAZIGRP],
	CONSTRAINT [DF_RISURAPP_TIPO_RISORSA] DEFAULT ('') FOR [TIPO_RISORSA],
	CONSTRAINT [DF_RISURAPP_TIPO_ATTIVITA] DEFAULT ('') FOR [TIPO_ATTIVITA],
	CONSTRAINT [DF_RISURAPP_MATRICOLA] DEFAULT ('') FOR [MATRICOLA],
	CONSTRAINT [DF_RISURAPP_CENTRCOM] DEFAULT ('') FOR [CENTRCOM],
	CONSTRAINT [DF_RISURAPP_IMPORTOLETTERE] DEFAULT ('') FOR [IMPORTOLETTERE],
	CONSTRAINT [DF_RISURAPP_DURATA_EFF] DEFAULT ('') FOR [DURATA_EFF],
	CONSTRAINT [DF_RISURAPP_UMPROVA] DEFAULT ('') FOR [UMPROVA],
	CONSTRAINT [DF_RISURAPP_D_FINE_EFF] DEFAULT ('') FOR [D_FINE_EFF]
GO

