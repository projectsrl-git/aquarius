
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[RisUBanc]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[RisUBanc]
GO


/****** Object:  Table [dbo].[RisUBanc]    Script Date: 25/01/2018 09:27:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[RisUBanc](
	[id_unique] [uniqueidentifier] ROWGUIDCOL  NOT NULL CONSTRAINT [DF_RisUBanc_id_unique]  DEFAULT (newid()),
	[DAGGANCIO] [varchar](32) NULL CONSTRAINT [DF_RisUBanc_DAGGANCIO]  DEFAULT (''),
	[ID_RISUBANC] [varchar](32) NULL CONSTRAINT [DF_RisUBanc_ID_RISUBANC]  DEFAULT (''),
	[DESCBANCA] [varchar](150) NULL CONSTRAINT [DF_RisUBanc_DESCBANCA]  DEFAULT (''),
	[INTESTATAR] [varchar](150) NULL CONSTRAINT [DF_RisUBanc_INTESTATAR]  DEFAULT (''),
	[ABI] [varchar](5) NULL CONSTRAINT [DF_RisUBanc_ABI]  DEFAULT (''),
	[CAB] [varchar](5) NULL CONSTRAINT [DF_RisUBanc_CAB]  DEFAULT (''),
	[CCN] [varchar](20) NULL CONSTRAINT [DF_RisUBanc_CCN]  DEFAULT (''),
	[CIN] [varchar](1) NULL CONSTRAINT [DF_RisUBanc_CIN]  DEFAULT (''),
	[B_RIFER] [varchar](1) NULL CONSTRAINT [DF_RisUBanc_B_RIFER]  DEFAULT (''),
	[ORDINE] [numeric](3, 0) NULL CONSTRAINT [DF_RisUBanc_ORDINE]  DEFAULT (0),
	[IBAN] [varchar](27) NULL CONSTRAINT [DF_risubanc_IBAN]  DEFAULT (''),
	[NAZION] [varchar](3) NULL CONSTRAINT [DF_risubanc_NAZION]  DEFAULT (''),
	[CHKDGT] [varchar](2) NULL CONSTRAINT [DF_risubanc_CHKDGT]  DEFAULT (''),
 CONSTRAINT [PK_RisUBanc] PRIMARY KEY CLUSTERED 
(
	[id_unique] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO




if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[RisUCost]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[RisUCost]
GO



/****** Object:  Table [dbo].[RisUCost]    Script Date: 25/01/2018 09:29:35 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[RisUCost](
	[id_unique] [uniqueidentifier] ROWGUIDCOL  NOT NULL CONSTRAINT [DF_RisUCost_id_unique]  DEFAULT (newid()),
	[DAGGANCIO] [varchar](32) NULL CONSTRAINT [DF_RisUCost_DAGGANCIO]  DEFAULT (''),
	[ID_COSTO] [varchar](32) NULL CONSTRAINT [DF_RisUCost_ID_COSTO]  DEFAULT (''),
	[D_Inizio_C] [varchar](10) NULL CONSTRAINT [DF_RisUCost_D_Inizio_C]  DEFAULT (''),
	[D_Fine_C] [varchar](10) NULL CONSTRAINT [DF_RisUCost_D_Fine_C]  DEFAULT (''),
	[COSTO_ORD] [numeric](17, 2) NULL CONSTRAINT [DF_RisUCost_COSTO_ORD]  DEFAULT (0),
	[COSTO_STR] [numeric](17, 2) NULL CONSTRAINT [DF_RisUCost_COSTO_STR]  DEFAULT (0),
	[COSTO_REP] [numeric](17, 2) NULL CONSTRAINT [DF_RisUCost_COSTO_REP]  DEFAULT (0),
	[COSTO_FES] [numeric](17, 2) NULL CONSTRAINT [DF_RisUCost_COSTO_FES]  DEFAULT (0),
	[COSTO_NOT] [numeric](17, 2) NULL CONSTRAINT [DF_RisUCost_COSTO_NOT]  DEFAULT (0),
	[ORDINE] [numeric](3, 0) NULL CONSTRAINT [DF_RisUCost_ORDINE]  DEFAULT (0),
	[B_INCORSO] [varchar](1) NULL CONSTRAINT [DF_RISUCOST_B_INCORSO]  DEFAULT (''),
	[HRTOGG] [numeric](2, 0) NULL CONSTRAINT [DF_RISUCOST_HRTOGG]  DEFAULT ((0)),
 CONSTRAINT [PK_RisUCost] PRIMARY KEY CLUSTERED 
(
	[id_unique] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO




if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[RisUFunz]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[RisUFunz]
GO


/****** Object:  Table [dbo].[RisUFunz]    Script Date: 25/01/2018 09:31:18 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[RisUFunz](
	[id_unique] [uniqueidentifier] ROWGUIDCOL  NOT NULL CONSTRAINT [DF_RisUFunz_id_unique]  DEFAULT (newid()),
	[DAGGANCIO] [varchar](32) NULL CONSTRAINT [DF_RisUFunz_DAGGANCIO]  DEFAULT (''),
	[ID_FUNZIONE] [varchar](32) NULL CONSTRAINT [DF_RisUFunz_ID_FUNZIONE]  DEFAULT (''),
	[IDFUNAZIEN] [varchar](32) NULL CONSTRAINT [DF_RisUFunz_IDFUNAZIEN]  DEFAULT (''),
	[D_Inizio_F] [varchar](10) NULL CONSTRAINT [DF_RisUFunz_D_Inizio_F]  DEFAULT (''),
	[D_Fine_F] [varchar](10) NULL CONSTRAINT [DF_RisUFunz_D_Fine_F]  DEFAULT (''),
	[B_InCorso] [varchar](1) NULL CONSTRAINT [DF_RisUFunz_B_InCorso]  DEFAULT (''),
	[ORDINE] [numeric](3, 0) NULL CONSTRAINT [DF_RisUFunz_ORDINE]  DEFAULT (0),
 CONSTRAINT [PK_RisUFunz] PRIMARY KEY CLUSTERED 
(
	[id_unique] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[RisURapp]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[RisURapp]
GO



/****** Object:  Table [dbo].[RisURapp]    Script Date: 25/01/2018 09:35:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[RisURapp](
	[id_unique] [uniqueidentifier] ROWGUIDCOL  NOT NULL CONSTRAINT [DF_RisURapp_id_unique]  DEFAULT (newid()),
	[DAGGANCIO] [varchar](32) NULL CONSTRAINT [DF_RisURapp_DAGGANCIO]  DEFAULT (''),
	[ID_RAPPORTO] [varchar](32) NULL CONSTRAINT [DF_RisURapp_ID_RAPPORTO]  DEFAULT (''),
	[TipoRapp] [varchar](32) NULL CONSTRAINT [DF_RisURapp_TipoRapp]  DEFAULT (''),
	[StatoRap] [varchar](32) NULL CONSTRAINT [DF_RisURapp_StatoRap]  DEFAULT (''),
	[D_Data] [varchar](10) NULL CONSTRAINT [DF_RisURapp_D_Data]  DEFAULT (''),
	[D_Inizio] [varchar](10) NULL CONSTRAINT [DF_RisURapp_D_Inizio]  DEFAULT (''),
	[D_Fine] [varchar](10) NULL CONSTRAINT [DF_RisURapp_D_Fine]  DEFAULT (''),
	[B_InCorso] [varchar](1) NULL CONSTRAINT [DF_RisURapp_B_InCorso]  DEFAULT (''),
	[Durata] [varchar](150) NULL CONSTRAINT [DF_RisURapp_Durata]  DEFAULT (''),
	[ProvaGG] [numeric](3, 0) NULL CONSTRAINT [DF_RisURapp_ProvaGG]  DEFAULT (0),
	[ImportoBase] [numeric](17, 2) NULL CONSTRAINT [DF_RisURapp_ImportoBase]  DEFAULT (0),
	[RifImporto] [numeric](3, 0) NULL CONSTRAINT [DF_RisURapp_RifImporto]  DEFAULT (0),
	[Livello] [varchar](100) NULL CONSTRAINT [DF_RisURapp_Livello]  DEFAULT (''),
	[EDR] [varchar](100) NULL CONSTRAINT [DF_RisURapp_EDR]  DEFAULT (''),
	[CodiceContr] [varchar](25) NULL CONSTRAINT [DF_RisURapp_CodiceContr]  DEFAULT (''),
	[DocContratt] [text] NULL CONSTRAINT [DF_RisURapp_DocContratt]  DEFAULT (''),
	[ORDINE] [numeric](3, 0) NULL CONSTRAINT [DF_RisURapp_ORDINE]  DEFAULT (0),
	[IDANAAZIEST] [varchar](10) NULL CONSTRAINT [DF_RISURAPP_IDANAAZIEST]  DEFAULT (''),
	[ANAAZIEST] [varchar](80) NULL CONSTRAINT [DF_RISURAPP_ANAAZIEST]  DEFAULT (''),
	[IDANAAZIGRP] [varchar](10) NULL CONSTRAINT [DF_RISURAPP_IDANAAZIGRP]  DEFAULT (''),
	[ANAAZIGRP] [varchar](80) NULL CONSTRAINT [DF_RISURAPP_ANAAZIGRP]  DEFAULT (''),
	[TIPO_RISORSA] [varchar](10) NULL CONSTRAINT [DF_RISURAPP_TIPO_RISORSA]  DEFAULT (''),
	[TIPO_ATTIVITA] [varchar](200) NULL CONSTRAINT [DF_RISURAPP_TIPO_ATTIVITA]  DEFAULT (''),
	[MATRICOLA] [varchar](6) NULL CONSTRAINT [DF_RISURAPP_MATRICOLA]  DEFAULT (''),
	[CENTRCOM] [varchar](5) NULL CONSTRAINT [DF_RISURAPP_CENTRCOM]  DEFAULT (''),
	[IMPORTOLETTERE] [varchar](150) NULL CONSTRAINT [DF_RISURAPP_IMPORTOLETTERE]  DEFAULT (''),
	[DURATA_EFF] [varchar](150) NULL CONSTRAINT [DF_RISURAPP_DURATA_EFF]  DEFAULT (''),
	[UMPROVA] [varchar](2) NULL CONSTRAINT [DF_RISURAPP_UMPROVA]  DEFAULT (''),
	[D_FINE_EFF] [varchar](150) NULL CONSTRAINT [DF_RISURAPP_D_FINE_EFF]  DEFAULT (''),
	[DocContratt1] [text] NULL CONSTRAINT [DF_RisURapp_DocContratt1]  DEFAULT (''),
	[DocContratt2] [text] NULL CONSTRAINT [DF_RisURapp_DocContratt2]  DEFAULT (''),
	[DocContratt3] [text] NULL CONSTRAINT [DF_RisURapp_DocContratt3]  DEFAULT (''),
	[CONTOCONT] [varchar](13) NULL CONSTRAINT [DF_RisURapp_CONTOCONT]  DEFAULT (''),
 CONSTRAINT [PK_RisURapp] PRIMARY KEY CLUSTERED 
(
	[id_unique] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO



/****** Object:  Table [dbo].[RISUMANA]    Script Date: 26/01/2018 09:56:06 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[RISUMANA](
	[id_unique] [uniqueidentifier] ROWGUIDCOL  NOT NULL CONSTRAINT [DF_RISUMANA_id_unique]  DEFAULT (newid()),
	[IDRisUmana] [varchar](32) NULL CONSTRAINT [DF_RISUMANA_IDRisUmana]  DEFAULT (''),
	[Curricul] [varchar](8) NULL CONSTRAINT [DF_RISUMANA_Curricul]  DEFAULT (''),
	[CentrCom] [varchar](5) NULL CONSTRAINT [DF_RISUMANA_CentrCom]  DEFAULT (''),
	[AnaAzi] [varchar](10) NULL CONSTRAINT [DF_RISUMANA_AnaAzi]  DEFAULT (''),
	[Codice] [varchar](16) NULL CONSTRAINT [DF_RISUMANA_Codice]  DEFAULT (''),
	[Cognome] [varchar](100) NULL CONSTRAINT [DF_RISUMANA_Cognome]  DEFAULT (''),
	[Nome] [varchar](50) NULL CONSTRAINT [DF_RISUMANA_Nome]  DEFAULT (''),
	[Sigla] [varchar](3) NULL CONSTRAINT [DF_RISUMANA_Sigla]  DEFAULT (''),
	[Sesso] [varchar](1) NULL CONSTRAINT [DF_RISUMANA_Sesso]  DEFAULT (''),
	[CodFiscale] [varchar](16) NULL CONSTRAINT [DF_RISUMANA_CodFiscale]  DEFAULT (''),
	[PartitaIva] [varchar](11) NULL CONSTRAINT [DF_RISUMANA_PartitaIva]  DEFAULT (''),
	[LocNascita] [varchar](120) NULL CONSTRAINT [DF_RISUMANA_LocNascita]  DEFAULT (''),
	[D_Nascita] [varchar](10) NULL CONSTRAINT [DF_RISUMANA_D_Nascita]  DEFAULT (''),
	[Eta] [numeric](17, 6) NULL CONSTRAINT [DF_RISUMANA_Eta]  DEFAULT ((0)),
	[LocResidenz] [varchar](120) NULL CONSTRAINT [DF_RISUMANA_LocResidenz]  DEFAULT (''),
	[IndResidenz] [varchar](100) NULL CONSTRAINT [DF_RISUMANA_IndResidenz]  DEFAULT (''),
	[CapResidenz] [varchar](5) NULL CONSTRAINT [DF_RISUMANA_CapResidenz]  DEFAULT (''),
	[LocDomicil] [varchar](120) NULL CONSTRAINT [DF_RISUMANA_LocDomicil]  DEFAULT (''),
	[IndDomicil] [varchar](100) NULL CONSTRAINT [DF_RISUMANA_IndDomicil]  DEFAULT (''),
	[CapDomicil] [varchar](5) NULL CONSTRAINT [DF_RISUMANA_CapDomicil]  DEFAULT (''),
	[TelDomicil] [varchar](50) NULL CONSTRAINT [DF_RISUMANA_TelDomicil]  DEFAULT (''),
	[FaxDom] [varchar](50) NULL CONSTRAINT [DF_RISUMANA_FaxDom]  DEFAULT (''),
	[FaxRes] [varchar](50) NULL CONSTRAINT [DF_RISUMANA_FaxRes]  DEFAULT (''),
	[TelFisso] [varchar](50) NULL CONSTRAINT [DF_RISUMANA_TelFisso]  DEFAULT (''),
	[TelMobile] [varchar](50) NULL CONSTRAINT [DF_RISUMANA_TelMobile]  DEFAULT (''),
	[EMail] [varchar](100) NULL CONSTRAINT [DF_RISUMANA_EMail]  DEFAULT (''),
	[Annotazioni] [varchar](255) NULL CONSTRAINT [DF_RISUMANA_Annotazioni]  DEFAULT (''),
	[B_RisSociet] [bit] NULL CONSTRAINT [DF_RISUMANA_B_RisSociet]  DEFAULT ((0)),
	[B_RisGruppo] [bit] NULL CONSTRAINT [DF_RISUMANA_B_RisGruppo]  DEFAULT ((0)),
	[B_RisEstern] [bit] NULL CONSTRAINT [DF_RISUMANA_B_RisEstern]  DEFAULT ((0)),
	[UtenteIns] [varchar](50) NULL CONSTRAINT [DF_RISUMANA_UtenteIns]  DEFAULT (''),
	[D_DataIns] [varchar](10) NULL CONSTRAINT [DF_RISUMANA_D_DataIns]  DEFAULT (''),
	[UtenteMod] [varchar](50) NULL CONSTRAINT [DF_RISUMANA_UtenteMod]  DEFAULT (''),
	[D_DataMod] [varchar](10) NULL CONSTRAINT [DF_RISUMANA_D_DataMod]  DEFAULT (''),
	[ModPag] [varchar](3) NULL CONSTRAINT [DF_RISUMANA_ModPag]  DEFAULT (''),
	[TermPagCli] [varchar](3) NULL CONSTRAINT [DF_RISUMANA_TermPagCli]  DEFAULT (''),
	[TermPagFor] [varchar](3) NULL CONSTRAINT [DF_RISUMANA_TermPagFor]  DEFAULT (''),
	[TAGGANCIO] [varchar](32) NULL CONSTRAINT [DF_RISUMANA_TAGGANCIO]  DEFAULT (''),
	[TIPO_RISORSA] [varchar](10) NULL CONSTRAINT [DF_RISUMANA_TIPO_RISORSA]  DEFAULT (''),
	[IDTITOLO] [varchar](32) NULL CONSTRAINT [DF_RISUMANA_IDTITOLO]  DEFAULT (''),
	[TELRESIDENZ] [varchar](50) NULL CONSTRAINT [DF_RISUMANA_TELRESIDENZ]  DEFAULT (''),
	[IDSTATORIS] [varchar](32) NULL CONSTRAINT [DF_RISUMANA_IDSTATORIS]  DEFAULT (''),
	[NAZIONE] [varchar](50) NULL CONSTRAINT [DF_RISUMANA_NAZIONE]  DEFAULT (''),
	[IDSTATOCIV] [varchar](32) NULL CONSTRAINT [DF_RISUMANA_IDSTATOCIV]  DEFAULT (''),
	[IDPOSMILIT] [varchar](32) NULL CONSTRAINT [DF_RISUMANA_IDPOSMILIT]  DEFAULT (''),
	[PAGCLI] [varchar](100) NULL CONSTRAINT [DF_RISUMANA_PAGCLI]  DEFAULT (''),
	[PAGFOR] [varchar](100) NULL CONSTRAINT [DF_RISUMANA_PAGFOR]  DEFAULT (''),
	[PASSWORD] [varchar](30) NULL CONSTRAINT [DF_RISUMANA_PASSWORD]  DEFAULT (''),
	[USERID] [varchar](30) NULL CONSTRAINT [DF_RISUMANA_USERID]  DEFAULT (''),
	[RUOLO] [varchar](30) NULL CONSTRAINT [DF_RISUMANA_RUOLO]  DEFAULT (''),
	[EMAIL1] [varchar](100) NULL CONSTRAINT [DF_RISUMANA_EMAIL1]  DEFAULT (''),
	[EMAIL2] [varchar](100) NULL CONSTRAINT [DF_RISUMANA_EMAIL2]  DEFAULT (''),
	[CCOST1] [varchar](13) NULL CONSTRAINT [DF_RISUMANA_CCOST1 ]  DEFAULT (''),
	[PERCON1] [numeric](17, 3) NULL CONSTRAINT [DF_RISUMANA_PERCON1 ]  DEFAULT ('0'),
 CONSTRAINT [PK_RISUMANA] PRIMARY KEY CLUSTERED 
(
	[id_unique] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO