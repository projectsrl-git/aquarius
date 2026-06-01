----------------------------------------------------------------------------------
--*** MEGA SCRIPT DI AGGIORNAMENTO DB AQUARIUS VARIE SOCIETA' CROSSOVERGROUP ***--
----------------------------------------------------------------------------------

--*** CREAZIONE TABELLA "ANAAZI"
--------------------------------
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ANAAZI]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ANAAZI]
GO
 
CREATE TABLE [dbo].[ANAAZI] (
	id_unique  uniqueidentifier ROWGUIDCOL  NOT NULL ,
	IDAnaAzi varchar(32) COLLATE Latin1_General_CI_AS NULL ,
	IDTipoAnag varchar(32) COLLATE Latin1_General_CI_AS NULL ,
	IDModPag varchar(32) COLLATE Latin1_General_CI_AS NULL ,
	IDTermPagCli varchar(32) COLLATE Latin1_General_CI_AS NULL ,
	IDTermPagFor varchar(32) COLLATE Latin1_General_CI_AS NULL ,
	IDComuneInd varchar(32) COLLATE Latin1_General_CI_AS NULL ,
	Codice varchar(16) COLLATE Latin1_General_CI_AS NULL ,
	RagSoc varchar(100) COLLATE Latin1_General_CI_AS NULL ,
	Acronimo varchar(100) COLLATE Latin1_General_CI_AS NULL ,
	Indiriz varchar(150) COLLATE Latin1_General_CI_AS NULL ,
	Cap varchar(5) COLLATE Latin1_General_CI_AS NULL ,
	ComuneInd varchar(250) COLLATE Latin1_General_CI_AS NULL ,
	Piva varchar(16) COLLATE Latin1_General_CI_AS NULL ,
	CdFisc varchar(16) COLLATE Latin1_General_CI_AS NULL ,
	Email varchar(150) COLLATE Latin1_General_CI_AS NULL ,
	SitoWeb varchar(250) COLLATE Latin1_General_CI_AS NULL ,
	Telefono varchar(50) COLLATE Latin1_General_CI_AS NULL ,
	Fax varchar(50) COLLATE Latin1_General_CI_AS NULL ,
	B_PerFis varchar(1) COLLATE Latin1_General_CI_AS NULL ,
	B_Client varchar(1) COLLATE Latin1_General_CI_AS NULL ,
	B_Fornit varchar(1) COLLATE Latin1_General_CI_AS NULL ,
	B_SocPro varchar(1) COLLATE Latin1_General_CI_AS NULL ,
	B_SocGrp varchar(1) COLLATE Latin1_General_CI_AS NULL ,
	B_IntGrp varchar(1) COLLATE Latin1_General_CI_AS NULL ,
	UtenteIns varchar(50) COLLATE Latin1_General_CI_AS NULL ,
	D_DataIns varchar(14) COLLATE Latin1_General_CI_AS NULL ,
	UtenteMod varchar(50) COLLATE Latin1_General_CI_AS NULL ,
	D_DataMod varchar(14) COLLATE Latin1_General_CI_AS NULL ,
	IDTitolo varchar(32) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[ANAAZI] WITH NOCHECK ADD 
	CONSTRAINT [PK_ANAAZI] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[ANAAZI] WITH NOCHECK ADD 
	CONSTRAINT [DF_ANAAZI_id_unique] DEFAULT (newid()) FOR [id_unique],
	CONSTRAINT [DF_ANAAZI_IDAnaAzi] DEFAULT ('') FOR [IDAnaAzi],
	CONSTRAINT [DF_ANAAZI_IDTipoAnag] DEFAULT ('') FOR [IDTipoAnag],
	CONSTRAINT [DF_ANAAZI_IDModPag] DEFAULT ('') FOR [IDModPag],
	CONSTRAINT [DF_ANAAZI_IDTermPagCli] DEFAULT ('') FOR [IDTermPagCli],
	CONSTRAINT [DF_ANAAZI_IDTermPagFor] DEFAULT ('') FOR [IDTermPagFor],
	CONSTRAINT [DF_ANAAZI_IDComuneInd] DEFAULT ('') FOR [IDComuneInd],
	CONSTRAINT [DF_ANAAZI_Codice] DEFAULT ('') FOR [Codice],
	CONSTRAINT [DF_ANAAZI_RagSoc] DEFAULT ('') FOR [RagSoc],
	CONSTRAINT [DF_ANAAZI_Acronimo] DEFAULT ('') FOR [Acronimo],
	CONSTRAINT [DF_ANAAZI_Indiriz] DEFAULT ('') FOR [Indiriz],
	CONSTRAINT [DF_ANAAZI_Cap] DEFAULT ('') FOR [Cap],
	CONSTRAINT [DF_ANAAZI_ComuneInd] DEFAULT ('') FOR [ComuneInd],
	CONSTRAINT [DF_ANAAZI_Piva] DEFAULT ('') FOR [Piva],
	CONSTRAINT [DF_ANAAZI_CdFisc] DEFAULT ('') FOR [CdFisc],
	CONSTRAINT [DF_ANAAZI_Email] DEFAULT ('') FOR [Email],
	CONSTRAINT [DF_ANAAZI_SitoWeb] DEFAULT ('') FOR [SitoWeb],
	CONSTRAINT [DF_ANAAZI_Telefono] DEFAULT ('') FOR [Telefono],
	CONSTRAINT [DF_ANAAZI_Fax] DEFAULT ('') FOR [Fax],
	CONSTRAINT [DF_ANAAZI_B_PerFis] DEFAULT ('') FOR [B_PerFis],
	CONSTRAINT [DF_ANAAZI_B_Client] DEFAULT ('') FOR [B_Client],
	CONSTRAINT [DF_ANAAZI_B_Fornit] DEFAULT ('') FOR [B_Fornit],
	CONSTRAINT [DF_ANAAZI_B_SocPro] DEFAULT ('') FOR [B_SocPro],
	CONSTRAINT [DF_ANAAZI_B_SocGrp] DEFAULT ('') FOR [B_SocGrp],
	CONSTRAINT [DF_ANAAZI_B_IntGrp] DEFAULT ('') FOR [B_IntGrp],
	CONSTRAINT [DF_ANAAZI_UtenteIns] DEFAULT ('') FOR [UtenteIns],
	CONSTRAINT [DF_ANAAZI_D_DataIns] DEFAULT ('') FOR [D_DataIns],
	CONSTRAINT [DF_ANAAZI_UtenteMod] DEFAULT ('') FOR [UtenteMod],
	CONSTRAINT [DF_ANAAZI_D_DataMod] DEFAULT ('') FOR [D_DataMod],
	CONSTRAINT [DF_ANAAZI_IDTitolo] DEFAULT ('') FOR [IDTitolo]
GO


--*** CREAZIONE TABELLA "RISUMANA"
----------------------------------
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[RISUMANA]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[RISUMANA]
GO
 
CREATE TABLE [dbo].[RISUMANA] (
	id_unique  uniqueidentifier ROWGUIDCOL  NOT NULL ,
	IDRisUmana varchar(32) COLLATE Latin1_General_CI_AS NULL ,
	IDCurricul varchar(32) COLLATE Latin1_General_CI_AS NULL ,
	IDCentrCom varchar(32) COLLATE Latin1_General_CI_AS NULL ,
	IDAnaAzi varchar(32) COLLATE Latin1_General_CI_AS NULL ,
	IDUtente varchar(32) COLLATE Latin1_General_CI_AS NULL ,
	Codice varchar(16) COLLATE Latin1_General_CI_AS NULL ,
	Curricul varchar(175) COLLATE Latin1_General_CI_AS NULL ,
	Cognome varchar(100) COLLATE Latin1_General_CI_AS NULL ,
	Nome varchar(50) COLLATE Latin1_General_CI_AS NULL ,
	Sigla varchar(3) COLLATE Latin1_General_CI_AS NULL ,
	Sesso varchar(1) COLLATE Latin1_General_CI_AS NULL ,
	CodFiscale varchar(16) COLLATE Latin1_General_CI_AS NULL ,
	PartitaIva varchar(11) COLLATE Latin1_General_CI_AS NULL ,
	LocNascita varchar(120) COLLATE Latin1_General_CI_AS NULL ,
	D_Nascita varchar(8) COLLATE Latin1_General_CI_AS NULL ,
	Eta numeric(17,6) NULL ,
	LocResidenz varchar(120) COLLATE Latin1_General_CI_AS NULL ,
	IndResidenz varchar(100) COLLATE Latin1_General_CI_AS NULL ,
	CapResidenz varchar(5) COLLATE Latin1_General_CI_AS NULL ,
	LocDomicil varchar(120) COLLATE Latin1_General_CI_AS NULL ,
	IndDomicil varchar(100) COLLATE Latin1_General_CI_AS NULL ,
	CapDomicil varchar(5) COLLATE Latin1_General_CI_AS NULL ,
	TelDomicil varchar(50) COLLATE Latin1_General_CI_AS NULL ,
	FaxDom varchar(50) COLLATE Latin1_General_CI_AS NULL ,
	FaxRes varchar(50) COLLATE Latin1_General_CI_AS NULL ,
	TelFisso varchar(50) COLLATE Latin1_General_CI_AS NULL ,
	TelMobile varchar(50) COLLATE Latin1_General_CI_AS NULL ,
	EMail varchar(100) COLLATE Latin1_General_CI_AS NULL ,
	Annotazioni varchar(255) COLLATE Latin1_General_CI_AS NULL ,
	B_RisSociet varchar(1) COLLATE Latin1_General_CI_AS NULL ,
	B_RisGruppo varchar(1) COLLATE Latin1_General_CI_AS NULL ,
	B_RisEstern varchar(1) COLLATE Latin1_General_CI_AS NULL ,
	UtenteIns varchar(50) COLLATE Latin1_General_CI_AS NULL ,
	D_DataIns varchar(14) COLLATE Latin1_General_CI_AS NULL ,
	UtenteMod varchar(50) COLLATE Latin1_General_CI_AS NULL ,
	D_DataMod varchar(14) COLLATE Latin1_General_CI_AS NULL ,
	IDModPag varchar(32) COLLATE Latin1_General_CI_AS NULL ,
	IDTermPagCli varchar(32) COLLATE Latin1_General_CI_AS NULL ,
	IDTermPagFor varchar(32) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[RISUMANA] WITH NOCHECK ADD 
	CONSTRAINT [PK_RISUMANA] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[RISUMANA] WITH NOCHECK ADD 
	CONSTRAINT [DF_RISUMANA_id_unique] DEFAULT (newid()) FOR [id_unique],
	CONSTRAINT [DF_RISUMANA_IDRisUmana] DEFAULT ('') FOR [IDRisUmana],
	CONSTRAINT [DF_RISUMANA_IDCurricul] DEFAULT ('') FOR [IDCurricul],
	CONSTRAINT [DF_RISUMANA_IDCentrCom] DEFAULT ('') FOR [IDCentrCom],
	CONSTRAINT [DF_RISUMANA_IDAnaAzi] DEFAULT ('') FOR [IDAnaAzi],
	CONSTRAINT [DF_RISUMANA_IDUtente] DEFAULT ('') FOR [IDUtente],
	CONSTRAINT [DF_RISUMANA_Codice] DEFAULT ('') FOR [Codice],
	CONSTRAINT [DF_RISUMANA_Curricul] DEFAULT ('') FOR [Curricul],
	CONSTRAINT [DF_RISUMANA_Cognome] DEFAULT ('') FOR [Cognome],
	CONSTRAINT [DF_RISUMANA_Nome] DEFAULT ('') FOR [Nome],
	CONSTRAINT [DF_RISUMANA_Sigla] DEFAULT ('') FOR [Sigla],
	CONSTRAINT [DF_RISUMANA_Sesso] DEFAULT ('') FOR [Sesso],
	CONSTRAINT [DF_RISUMANA_CodFiscale] DEFAULT ('') FOR [CodFiscale],
	CONSTRAINT [DF_RISUMANA_PartitaIva] DEFAULT ('') FOR [PartitaIva],
	CONSTRAINT [DF_RISUMANA_LocNascita] DEFAULT ('') FOR [LocNascita],
	CONSTRAINT [DF_RISUMANA_D_Nascita] DEFAULT ('') FOR [D_Nascita],
	CONSTRAINT [DF_RISUMANA_Eta] DEFAULT (0) FOR [Eta],
	CONSTRAINT [DF_RISUMANA_LocResidenz] DEFAULT ('') FOR [LocResidenz],
	CONSTRAINT [DF_RISUMANA_IndResidenz] DEFAULT ('') FOR [IndResidenz],
	CONSTRAINT [DF_RISUMANA_CapResidenz] DEFAULT ('') FOR [CapResidenz],
	CONSTRAINT [DF_RISUMANA_LocDomicil] DEFAULT ('') FOR [LocDomicil],
	CONSTRAINT [DF_RISUMANA_IndDomicil] DEFAULT ('') FOR [IndDomicil],
	CONSTRAINT [DF_RISUMANA_CapDomicil] DEFAULT ('') FOR [CapDomicil],
	CONSTRAINT [DF_RISUMANA_TelDomicil] DEFAULT ('') FOR [TelDomicil],
	CONSTRAINT [DF_RISUMANA_FaxDom] DEFAULT ('') FOR [FaxDom],
	CONSTRAINT [DF_RISUMANA_FaxRes] DEFAULT ('') FOR [FaxRes],
	CONSTRAINT [DF_RISUMANA_TelFisso] DEFAULT ('') FOR [TelFisso],
	CONSTRAINT [DF_RISUMANA_TelMobile] DEFAULT ('') FOR [TelMobile],
	CONSTRAINT [DF_RISUMANA_EMail] DEFAULT ('') FOR [EMail],
	CONSTRAINT [DF_RISUMANA_Annotazioni] DEFAULT ('') FOR [Annotazioni],
	CONSTRAINT [DF_RISUMANA_B_RisSociet] DEFAULT ('') FOR [B_RisSociet],
	CONSTRAINT [DF_RISUMANA_B_RisGruppo] DEFAULT ('') FOR [B_RisGruppo],
	CONSTRAINT [DF_RISUMANA_B_RisEstern] DEFAULT ('') FOR [B_RisEstern],
	CONSTRAINT [DF_RISUMANA_UtenteIns] DEFAULT ('') FOR [UtenteIns],
	CONSTRAINT [DF_RISUMANA_D_DataIns] DEFAULT ('') FOR [D_DataIns],
	CONSTRAINT [DF_RISUMANA_UtenteMod] DEFAULT ('') FOR [UtenteMod],
	CONSTRAINT [DF_RISUMANA_D_DataMod] DEFAULT ('') FOR [D_DataMod],
	CONSTRAINT [DF_RISUMANA_IDModPag] DEFAULT ('') FOR [IDModPag],
	CONSTRAINT [DF_RISUMANA_IDTermPagCli] DEFAULT ('') FOR [IDTermPagCli],
	CONSTRAINT [DF_RISUMANA_IDTermPagFor] DEFAULT ('') FOR [IDTermPagFor]
GO



--*** CREAZIONE TABELLA "COMMESSA"
----------------------------------
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[COMMESSA]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[COMMESSA]
GO
 
CREATE TABLE [dbo].[COMMESSA] (
	id_unique  uniqueidentifier ROWGUIDCOL  NOT NULL ,
	IDCommessa varchar(32) COLLATE Latin1_General_CI_AS NULL ,
	IDTrattCom varchar(32) COLLATE Latin1_General_CI_AS NULL ,
	IDRisUResp varchar(32) COLLATE Latin1_General_CI_AS NULL ,
	IDCentrComP varchar(32) COLLATE Latin1_General_CI_AS NULL ,
	IDCentrCom varchar(32) COLLATE Latin1_General_CI_AS NULL ,
	IDAreaMerc varchar(32) COLLATE Latin1_General_CI_AS NULL ,
	IDClassTC varchar(32) COLLATE Latin1_General_CI_AS NULL ,
	B_Interna varchar(1) COLLATE Latin1_General_CI_AS NULL ,
	B_ClienteSn varchar(1) COLLATE Latin1_General_CI_AS NULL ,
	TrattCom varchar(100) COLLATE Latin1_General_CI_AS NULL ,
	Codice varchar(25) COLLATE Latin1_General_CI_AS NULL ,
	D_Data varchar(8) COLLATE Latin1_General_CI_AS NULL ,
	D_Inizio varchar(8) COLLATE Latin1_General_CI_AS NULL ,
	D_Fine varchar(8) COLLATE Latin1_General_CI_AS NULL ,
	Titolo varchar(255) COLLATE Latin1_General_CI_AS NULL ,
	Annotazioni text COLLATE Latin1_General_CI_AS NULL ,
	UtenteIns varchar(50) COLLATE Latin1_General_CI_AS NULL ,
	D_DataIns varchar(14) COLLATE Latin1_General_CI_AS NULL ,
	UtenteMod varchar(50) COLLATE Latin1_General_CI_AS NULL ,
	D_DataMod varchar(14) COLLATE Latin1_General_CI_AS NULL ,
	NoteFatt text COLLATE Latin1_General_CI_AS NULL ,
	FlgFatt bit NULL ,
	CodAqua varchar(10) COLLATE Latin1_General_CI_AS NULL ,
	Fat_CodCdc varchar(05) COLLATE Latin1_General_CI_AS NULL ,
	Fat_NumOrc varchar(06) COLLATE Latin1_General_CI_AS NULL ,
	Fat_DatOrc varchar(08) COLLATE Latin1_General_CI_AS NULL ,
	Fat_NumOfc varchar(30) COLLATE Latin1_General_CI_AS NULL ,
	Fat_DatOfc varchar(08) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[COMMESSA] WITH NOCHECK ADD 
	CONSTRAINT [PK_COMMESSA] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[COMMESSA] WITH NOCHECK ADD 
	CONSTRAINT [DF_COMMESSA_id_unique] DEFAULT (newid()) FOR [id_unique],
	CONSTRAINT [DF_COMMESSA_IDCommessa] DEFAULT ('') FOR [IDCommessa],
	CONSTRAINT [DF_COMMESSA_IDTrattCom] DEFAULT ('') FOR [IDTrattCom],
	CONSTRAINT [DF_COMMESSA_IDRisUResp] DEFAULT ('') FOR [IDRisUResp],
	CONSTRAINT [DF_COMMESSA_IDCentrComP] DEFAULT ('') FOR [IDCentrComP],
	CONSTRAINT [DF_COMMESSA_IDCentrCom] DEFAULT ('') FOR [IDCentrCom],
	CONSTRAINT [DF_COMMESSA_IDAreaMerc] DEFAULT ('') FOR [IDAreaMerc],
	CONSTRAINT [DF_COMMESSA_IDClassTC] DEFAULT ('') FOR [IDClassTC],
	CONSTRAINT [DF_COMMESSA_B_Interna] DEFAULT ('') FOR [B_Interna],
	CONSTRAINT [DF_COMMESSA_B_ClienteSn] DEFAULT ('') FOR [B_ClienteSn],
	CONSTRAINT [DF_COMMESSA_TrattCom] DEFAULT ('') FOR [TrattCom],
	CONSTRAINT [DF_COMMESSA_Codice] DEFAULT ('') FOR [Codice],
	CONSTRAINT [DF_COMMESSA_D_Data] DEFAULT ('') FOR [D_Data],
	CONSTRAINT [DF_COMMESSA_D_Inizio] DEFAULT ('') FOR [D_Inizio],
	CONSTRAINT [DF_COMMESSA_D_Fine] DEFAULT ('') FOR [D_Fine],
	CONSTRAINT [DF_COMMESSA_Titolo] DEFAULT ('') FOR [Titolo],
	CONSTRAINT [DF_COMMESSA_Annotazioni] DEFAULT ('') FOR [Annotazioni],
	CONSTRAINT [DF_COMMESSA_UtenteIns] DEFAULT ('') FOR [UtenteIns],
	CONSTRAINT [DF_COMMESSA_D_DataIns] DEFAULT ('') FOR [D_DataIns],
	CONSTRAINT [DF_COMMESSA_UtenteMod] DEFAULT ('') FOR [UtenteMod],
	CONSTRAINT [DF_COMMESSA_D_DataMod] DEFAULT ('') FOR [D_DataMod],
	CONSTRAINT [DF_COMMESSA_NoteFatt] DEFAULT ('') FOR [NoteFatt],
	CONSTRAINT [DF_COMMESSA_FlgFatt] DEFAULT (0) FOR [FlgFatt],
	CONSTRAINT [DF_COMMESSA_CodAqua] DEFAULT ('') FOR [CodAqua],
	CONSTRAINT [DF_COMMESSA_Fat_CodCdc] DEFAULT ('') FOR [Fat_CodCdc],
	CONSTRAINT [DF_COMMESSA_Fat_NumOrc] DEFAULT ('') FOR [Fat_NumOrc],
	CONSTRAINT [DF_COMMESSA_Fat_DatOrc] DEFAULT ('') FOR [Fat_DatOrc],
	CONSTRAINT [DF_COMMESSA_Fat_NumOfc] DEFAULT ('') FOR [Fat_NumOfc],
	CONSTRAINT [DF_COMMESSA_Fat_DatOfc] DEFAULT ('') FOR [Fat_DatOfc]
GO



--*** CREAZIONE TABELLA "TIMESHT"
---------------------------------
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[TIMESHT]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[TIMESHT]
GO
 
CREATE TABLE [dbo].[TIMESHT] (
	id_unique  uniqueidentifier ROWGUIDCOL  NOT NULL ,
	IDTimeSht varchar(32) COLLATE Latin1_General_CI_AS NULL ,
	IDRisUmana varchar(32) COLLATE Latin1_General_CI_AS NULL ,
	IDCompXCom varchar(32) COLLATE Latin1_General_CI_AS NULL ,
	IDTipoOra varchar(32) COLLATE Latin1_General_CI_AS NULL ,
	IDDettOra varchar(32) COLLATE Latin1_General_CI_AS NULL ,
	D_Data varchar(8) COLLATE Latin1_General_CI_AS NULL ,
	Minuti numeric(17,6) NULL ,
	Ore numeric(17,6) NULL ,
	B_Bloccato varchar(1) COLLATE Latin1_General_CI_AS NULL ,
	Annotazioni text COLLATE Latin1_General_CI_AS NULL ,
	UtenteIns varchar(50) COLLATE Latin1_General_CI_AS NULL ,
	D_DataIns varchar(14) COLLATE Latin1_General_CI_AS NULL ,
	UtenteMod varchar(50) COLLATE Latin1_General_CI_AS NULL ,
	D_DataMod varchar(14) COLLATE Latin1_General_CI_AS NULL ,
	FlgFatt bit NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[TIMESHT] WITH NOCHECK ADD 
	CONSTRAINT [PK_TIMESHT] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[TIMESHT] WITH NOCHECK ADD 
	CONSTRAINT [DF_TIMESHT_id_unique] DEFAULT (newid()) FOR [id_unique],
	CONSTRAINT [DF_TIMESHT_IDTimeSht] DEFAULT ('') FOR [IDTimeSht],
	CONSTRAINT [DF_TIMESHT_IDRisUmana] DEFAULT ('') FOR [IDRisUmana],
	CONSTRAINT [DF_TIMESHT_IDCompXCom] DEFAULT ('') FOR [IDCompXCom],
	CONSTRAINT [DF_TIMESHT_IDTipoOra] DEFAULT ('') FOR [IDTipoOra],
	CONSTRAINT [DF_TIMESHT_IDDettOra] DEFAULT ('') FOR [IDDettOra],
	CONSTRAINT [DF_TIMESHT_D_Data] DEFAULT ('') FOR [D_Data],
	CONSTRAINT [DF_TIMESHT_Minuti] DEFAULT (0) FOR [Minuti],
	CONSTRAINT [DF_TIMESHT_Ore] DEFAULT (0) FOR [Ore],
	CONSTRAINT [DF_TIMESHT_B_Bloccato] DEFAULT ('') FOR [B_Bloccato],
	CONSTRAINT [DF_TIMESHT_Annotazioni] DEFAULT ('') FOR [Annotazioni],
	CONSTRAINT [DF_TIMESHT_UtenteIns] DEFAULT ('') FOR [UtenteIns],
	CONSTRAINT [DF_TIMESHT_D_DataIns] DEFAULT ('') FOR [D_DataIns],
	CONSTRAINT [DF_TIMESHT_UtenteMod] DEFAULT ('') FOR [UtenteMod],
	CONSTRAINT [DF_TIMESHT_D_DataMod] DEFAULT ('') FOR [D_DataMod],
	CONSTRAINT [DF_TIMESHT_FlgFatt] DEFAULT (0) FOR [FlgFatt]
GO




--*** CREAZIONE TABELLA "U_STO_TS"
----------------------------------
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[U_STO_TS]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[U_STO_TS]
GO
 
CREATE TABLE [dbo].[U_STO_TS] (

	id_unique  uniqueidentifier ROWGUIDCOL  NOT NULL ,
	IDTimeSht varchar(32) COLLATE Latin1_General_CI_AS NULL ,
	IDRisUmana varchar(32) COLLATE Latin1_General_CI_AS NULL ,
	IDCompXCom varchar(32) COLLATE Latin1_General_CI_AS NULL ,
	IDTipoOra varchar(32) COLLATE Latin1_General_CI_AS NULL ,
	IDDettOra varchar(32) COLLATE Latin1_General_CI_AS NULL ,
	D_Data varchar(8) COLLATE Latin1_General_CI_AS NULL ,
	Minuti numeric(17,6) NULL ,
	Ore numeric(17,6) NULL ,
	B_Bloccato varchar(1) COLLATE Latin1_General_CI_AS NULL ,
	Annotazioni text COLLATE Latin1_General_CI_AS NULL ,
	UtenteIns varchar(50) COLLATE Latin1_General_CI_AS NULL ,
	D_DataIns varchar(14) COLLATE Latin1_General_CI_AS NULL ,
	UtenteMod varchar(50) COLLATE Latin1_General_CI_AS NULL ,
	D_DataMod varchar(14) COLLATE Latin1_General_CI_AS NULL ,
	FlgFatt bit NULL ,

	IDCurricul varchar(32) COLLATE Latin1_General_CI_AS NULL ,
	IDCentrCom varchar(32) COLLATE Latin1_General_CI_AS NULL ,
	IDAnaAzi_RisUmana varchar(32) COLLATE Latin1_General_CI_AS NULL ,
	IDUtente varchar(32) COLLATE Latin1_General_CI_AS NULL ,
	Codice varchar(16) COLLATE Latin1_General_CI_AS NULL ,
	Curricul varchar(175) COLLATE Latin1_General_CI_AS NULL ,
	Cognome varchar(100) COLLATE Latin1_General_CI_AS NULL ,
	Nome varchar(50) COLLATE Latin1_General_CI_AS NULL ,
	Sigla varchar(3) COLLATE Latin1_General_CI_AS NULL ,
	Sesso varchar(1) COLLATE Latin1_General_CI_AS NULL ,
	CodFiscale varchar(16) COLLATE Latin1_General_CI_AS NULL ,
	PartitaIva varchar(11) COLLATE Latin1_General_CI_AS NULL ,
	LocNascita varchar(120) COLLATE Latin1_General_CI_AS NULL ,
	D_Nascita varchar(8) COLLATE Latin1_General_CI_AS NULL ,
	Eta numeric(17,6) NULL ,
	LocResidenz varchar(120) COLLATE Latin1_General_CI_AS NULL ,
	IndResidenz varchar(100) COLLATE Latin1_General_CI_AS NULL ,
	CapResidenz varchar(5) COLLATE Latin1_General_CI_AS NULL ,
	LocDomicil varchar(120) COLLATE Latin1_General_CI_AS NULL ,
	IndDomicil varchar(100) COLLATE Latin1_General_CI_AS NULL ,
	CapDomicil varchar(5) COLLATE Latin1_General_CI_AS NULL ,
	TelDomicil varchar(50) COLLATE Latin1_General_CI_AS NULL ,
	FaxDom varchar(50) COLLATE Latin1_General_CI_AS NULL ,
	FaxRes varchar(50) COLLATE Latin1_General_CI_AS NULL ,
	TelFisso varchar(50) COLLATE Latin1_General_CI_AS NULL ,
	TelMobile varchar(50) COLLATE Latin1_General_CI_AS NULL ,
	EMail varchar(100) COLLATE Latin1_General_CI_AS NULL ,
	Annotazioni_RisUmana varchar(255) COLLATE Latin1_General_CI_AS NULL ,
	B_RisSociet varchar(1) COLLATE Latin1_General_CI_AS NULL ,
	B_RisGruppo varchar(1) COLLATE Latin1_General_CI_AS NULL ,
	B_RisEstern varchar(1) COLLATE Latin1_General_CI_AS NULL ,
	IDModPag varchar(32) COLLATE Latin1_General_CI_AS NULL ,
	IDTermPagCli varchar(32) COLLATE Latin1_General_CI_AS NULL ,
	IDTermPagFor varchar(32) COLLATE Latin1_General_CI_AS NULL ,

	IDCommessa varchar(32) COLLATE Latin1_General_CI_AS NULL ,
	IDTrattCom varchar(32) COLLATE Latin1_General_CI_AS NULL ,
	IDRisUResp varchar(32) COLLATE Latin1_General_CI_AS NULL ,
	IDCentrComP varchar(32) COLLATE Latin1_General_CI_AS NULL ,
	IDCentrCom_Commessa varchar(32) COLLATE Latin1_General_CI_AS NULL ,
	IDAreaMerc varchar(32) COLLATE Latin1_General_CI_AS NULL ,
	IDClassTC varchar(32) COLLATE Latin1_General_CI_AS NULL ,
	B_Interna varchar(1) COLLATE Latin1_General_CI_AS NULL ,
	B_ClienteSn varchar(1) COLLATE Latin1_General_CI_AS NULL ,
	TrattCom varchar(100) COLLATE Latin1_General_CI_AS NULL ,
	Codice_Commessa varchar(25) COLLATE Latin1_General_CI_AS NULL ,
	D_Data_Commessa varchar(8) COLLATE Latin1_General_CI_AS NULL ,
	D_Inizio varchar(8) COLLATE Latin1_General_CI_AS NULL ,
	D_Fine varchar(8) COLLATE Latin1_General_CI_AS NULL ,
	Titolo varchar(255) COLLATE Latin1_General_CI_AS NULL ,
	Annotazioni_Commessa text COLLATE Latin1_General_CI_AS NULL ,
	NoteFatt text COLLATE Latin1_General_CI_AS NULL ,
	FlgFatt_Commessa bit NULL ,
	CodAqua varchar(10) COLLATE Latin1_General_CI_AS NULL ,
	Fat_CodCdc varchar(05) COLLATE Latin1_General_CI_AS NULL ,
	Fat_NumOrc varchar(06) COLLATE Latin1_General_CI_AS NULL ,
	Fat_DatOrc varchar(08) COLLATE Latin1_General_CI_AS NULL ,
	Fat_NumOfc varchar(30) COLLATE Latin1_General_CI_AS NULL ,
	Fat_DatOfc varchar(08) COLLATE Latin1_General_CI_AS NULL ,

	IDAnaAzi varchar(32) COLLATE Latin1_General_CI_AS NULL ,
	IDTipoAnag varchar(32) COLLATE Latin1_General_CI_AS NULL ,
	IDModPag_AnaAzi varchar(32) COLLATE Latin1_General_CI_AS NULL ,
	IDTermPagCli_AnaAzi varchar(32) COLLATE Latin1_General_CI_AS NULL ,
	IDTermPagFor_AnaAzi varchar(32) COLLATE Latin1_General_CI_AS NULL ,
	IDComuneInd varchar(32) COLLATE Latin1_General_CI_AS NULL ,
	Codice_AnaAzi varchar(16) COLLATE Latin1_General_CI_AS NULL ,
	RagSoc varchar(100) COLLATE Latin1_General_CI_AS NULL ,
	Acronimo varchar(100) COLLATE Latin1_General_CI_AS NULL ,
	Indiriz varchar(150) COLLATE Latin1_General_CI_AS NULL ,
	Cap varchar(5) COLLATE Latin1_General_CI_AS NULL ,
	ComuneInd varchar(250) COLLATE Latin1_General_CI_AS NULL ,
	Piva varchar(16) COLLATE Latin1_General_CI_AS NULL ,
	CdFisc varchar(16) COLLATE Latin1_General_CI_AS NULL ,
	Email_AnaAzi varchar(150) COLLATE Latin1_General_CI_AS NULL ,
	SitoWeb varchar(250) COLLATE Latin1_General_CI_AS NULL ,
	Telefono varchar(50) COLLATE Latin1_General_CI_AS NULL ,
	Fax varchar(50) COLLATE Latin1_General_CI_AS NULL ,
	B_PerFis varchar(1) COLLATE Latin1_General_CI_AS NULL ,
	B_Client varchar(1) COLLATE Latin1_General_CI_AS NULL ,
	B_Fornit varchar(1) COLLATE Latin1_General_CI_AS NULL ,
	B_SocPro varchar(1) COLLATE Latin1_General_CI_AS NULL ,
	B_SocGrp varchar(1) COLLATE Latin1_General_CI_AS NULL ,
	B_IntGrp varchar(1) COLLATE Latin1_General_CI_AS NULL ,
	IDTitolo varchar(32) COLLATE Latin1_General_CI_AS NULL

) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[U_STO_TS] WITH NOCHECK ADD 
	CONSTRAINT [PK_U_STO_TS] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[U_STO_TS] WITH NOCHECK ADD 

	CONSTRAINT [DF_U_STO_TS_id_unique] DEFAULT (newid()) FOR [id_unique],
	CONSTRAINT [DF_U_STO_TS_IDTimeSht] DEFAULT ('') FOR [IDTimeSht],
	CONSTRAINT [DF_U_STO_TS_IDRisUmana] DEFAULT ('') FOR [IDRisUmana],
	CONSTRAINT [DF_U_STO_TS_IDCompXCom] DEFAULT ('') FOR [IDCompXCom],
	CONSTRAINT [DF_U_STO_TS_IDTipoOra] DEFAULT ('') FOR [IDTipoOra],
	CONSTRAINT [DF_U_STO_TS_IDDettOra] DEFAULT ('') FOR [IDDettOra],
	CONSTRAINT [DF_U_STO_TS_D_Data] DEFAULT ('') FOR [D_Data],
	CONSTRAINT [DF_U_STO_TS_Minuti] DEFAULT (0) FOR [Minuti],
	CONSTRAINT [DF_U_STO_TS_Ore] DEFAULT (0) FOR [Ore],
	CONSTRAINT [DF_U_STO_TS_B_Bloccato] DEFAULT ('') FOR [B_Bloccato],
	CONSTRAINT [DF_U_STO_TS_Annotazioni] DEFAULT ('') FOR [Annotazioni],
	CONSTRAINT [DF_U_STO_TS_UtenteIns] DEFAULT ('') FOR [UtenteIns],
	CONSTRAINT [DF_U_STO_TS_D_DataIns] DEFAULT ('') FOR [D_DataIns],
	CONSTRAINT [DF_U_STO_TS_UtenteMod] DEFAULT ('') FOR [UtenteMod],
	CONSTRAINT [DF_U_STO_TS_D_DataMod] DEFAULT ('') FOR [D_DataMod],
	CONSTRAINT [DF_U_STO_TS_FlgFatt] DEFAULT (0) FOR [FlgFatt],


	CONSTRAINT [DF_U_STO_TS_IDCurricul] DEFAULT ('') FOR [IDCurricul],
	CONSTRAINT [DF_U_STO_TS_IDCentrCom] DEFAULT ('') FOR [IDCentrCom],
	CONSTRAINT [DF_U_STO_TS_IDAnaAzi_RisUmana] DEFAULT ('') FOR [IDAnaAzi_RisUmana],
	CONSTRAINT [DF_U_STO_TS_IDUtente] DEFAULT ('') FOR [IDUtente],
	CONSTRAINT [DF_U_STO_TS_Codice] DEFAULT ('') FOR [Codice],
	CONSTRAINT [DF_U_STO_TS_Curricul] DEFAULT ('') FOR [Curricul],
	CONSTRAINT [DF_U_STO_TS_Cognome] DEFAULT ('') FOR [Cognome],
	CONSTRAINT [DF_U_STO_TS_Nome] DEFAULT ('') FOR [Nome],
	CONSTRAINT [DF_U_STO_TS_Sigla] DEFAULT ('') FOR [Sigla],
	CONSTRAINT [DF_U_STO_TS_Sesso] DEFAULT ('') FOR [Sesso],
	CONSTRAINT [DF_U_STO_TS_CodFiscale] DEFAULT ('') FOR [CodFiscale],
	CONSTRAINT [DF_U_STO_TS_PartitaIva] DEFAULT ('') FOR [PartitaIva],
	CONSTRAINT [DF_U_STO_TS_LocNascita] DEFAULT ('') FOR [LocNascita],
	CONSTRAINT [DF_U_STO_TS_D_Nascita] DEFAULT ('') FOR [D_Nascita],
	CONSTRAINT [DF_U_STO_TS_Eta] DEFAULT (0) FOR [Eta],
	CONSTRAINT [DF_U_STO_TS_LocResidenz] DEFAULT ('') FOR [LocResidenz],
	CONSTRAINT [DF_U_STO_TS_IndResidenz] DEFAULT ('') FOR [IndResidenz],
	CONSTRAINT [DF_U_STO_TS_CapResidenz] DEFAULT ('') FOR [CapResidenz],
	CONSTRAINT [DF_U_STO_TS_LocDomicil] DEFAULT ('') FOR [LocDomicil],
	CONSTRAINT [DF_U_STO_TS_IndDomicil] DEFAULT ('') FOR [IndDomicil],
	CONSTRAINT [DF_U_STO_TS_CapDomicil] DEFAULT ('') FOR [CapDomicil],
	CONSTRAINT [DF_U_STO_TS_TelDomicil] DEFAULT ('') FOR [TelDomicil],
	CONSTRAINT [DF_U_STO_TS_FaxDom] DEFAULT ('') FOR [FaxDom],
	CONSTRAINT [DF_U_STO_TS_FaxRes] DEFAULT ('') FOR [FaxRes],
	CONSTRAINT [DF_U_STO_TS_TelFisso] DEFAULT ('') FOR [TelFisso],
	CONSTRAINT [DF_U_STO_TS_TelMobile] DEFAULT ('') FOR [TelMobile],
	CONSTRAINT [DF_U_STO_TS_EMail] DEFAULT ('') FOR [EMail],
	CONSTRAINT [DF_U_STO_TS_Annotazioni_RisUmana] DEFAULT ('') FOR [Annotazioni_RisUmana],
	CONSTRAINT [DF_U_STO_TS_B_RisSociet] DEFAULT ('') FOR [B_RisSociet],
	CONSTRAINT [DF_U_STO_TS_B_RisGruppo] DEFAULT ('') FOR [B_RisGruppo],
	CONSTRAINT [DF_U_STO_TS_B_RisEstern] DEFAULT ('') FOR [B_RisEstern],
	CONSTRAINT [DF_U_STO_TS_IDModPag] DEFAULT ('') FOR [IDModPag],
	CONSTRAINT [DF_U_STO_TS_IDTermPagCli] DEFAULT ('') FOR [IDTermPagCli],
	CONSTRAINT [DF_U_STO_TS_IDTermPagFor] DEFAULT ('') FOR [IDTermPagFor],

	CONSTRAINT [DF_U_STO_TS_IDCommessa] DEFAULT ('') FOR [IDCommessa],
	CONSTRAINT [DF_U_STO_TS_IDTrattCom] DEFAULT ('') FOR [IDTrattCom],
	CONSTRAINT [DF_U_STO_TS_IDRisUResp] DEFAULT ('') FOR [IDRisUResp],
	CONSTRAINT [DF_U_STO_TS_IDCentrComP] DEFAULT ('') FOR [IDCentrComP],
	CONSTRAINT [DF_U_STO_TS_IDCentrCom_Commessa] DEFAULT ('') FOR [IDCentrCom_Commessa],
	CONSTRAINT [DF_U_STO_TS_IDAreaMerc] DEFAULT ('') FOR [IDAreaMerc],
	CONSTRAINT [DF_U_STO_TS_IDClassTC] DEFAULT ('') FOR [IDClassTC],
	CONSTRAINT [DF_U_STO_TS_B_Interna] DEFAULT ('') FOR [B_Interna],
	CONSTRAINT [DF_U_STO_TS_B_ClienteSn] DEFAULT ('') FOR [B_ClienteSn],
	CONSTRAINT [DF_U_STO_TS_TrattCom] DEFAULT ('') FOR [TrattCom],
	CONSTRAINT [DF_U_STO_TS_Codice_Commessa] DEFAULT ('') FOR [Codice_Commessa],
	CONSTRAINT [DF_U_STO_TS_D_Data_Commessa] DEFAULT ('') FOR [D_Data_Commessa],
	CONSTRAINT [DF_U_STO_TS_D_Inizio] DEFAULT ('') FOR [D_Inizio],
	CONSTRAINT [DF_U_STO_TS_D_Fine] DEFAULT ('') FOR [D_Fine],
	CONSTRAINT [DF_U_STO_TS_Titolo] DEFAULT ('') FOR [Titolo],
	CONSTRAINT [DF_U_STO_TS_Annotazioni_Commessa] DEFAULT ('') FOR [Annotazioni_Commessa],
	CONSTRAINT [DF_U_STO_TS_NoteFatt] DEFAULT ('') FOR [NoteFatt],
	CONSTRAINT [DF_U_STO_TS_FlgFatt_Commessa] DEFAULT (0) FOR [FlgFatt_Commessa],
	CONSTRAINT [DF_U_STO_TS_CodAqua] DEFAULT ('') FOR [CodAqua],
	CONSTRAINT [DF_U_STO_TS_Fat_CodCdc] DEFAULT ('') FOR [Fat_CodCdc],
	CONSTRAINT [DF_U_STO_TS_Fat_NumOrc] DEFAULT ('') FOR [Fat_NumOrc],
	CONSTRAINT [DF_U_STO_TS_Fat_DatOrc] DEFAULT ('') FOR [Fat_DatOrc],
	CONSTRAINT [DF_U_STO_TS_Fat_NumOfc] DEFAULT ('') FOR [Fat_NumOfc],
	CONSTRAINT [DF_U_STO_TS_Fat_DatOfc] DEFAULT ('') FOR [Fat_DatOfc],

	CONSTRAINT [DF_U_STO_TS_IDAnaAzi] DEFAULT ('') FOR [IDAnaAzi],
	CONSTRAINT [DF_U_STO_TS_IDTipoAnag] DEFAULT ('') FOR [IDTipoAnag],
	CONSTRAINT [DF_U_STO_TS_IDModPag_AnaAzi] DEFAULT ('') FOR [IDModPag_AnaAzi],
	CONSTRAINT [DF_U_STO_TS_IDTermPagCli_AnaAzi] DEFAULT ('') FOR [IDTermPagCli_AnaAzi],
	CONSTRAINT [DF_U_STO_TS_IDTermPagFor_AnaAzi] DEFAULT ('') FOR [IDTermPagFor_AnaAzi],
	CONSTRAINT [DF_U_STO_TS_IDComuneInd] DEFAULT ('') FOR [IDComuneInd],
	CONSTRAINT [DF_U_STO_TS_Codice_AnaAzi] DEFAULT ('') FOR [Codice_AnaAzi],
	CONSTRAINT [DF_U_STO_TS_RagSoc] DEFAULT ('') FOR [RagSoc],
	CONSTRAINT [DF_U_STO_TS_Acronimo] DEFAULT ('') FOR [Acronimo],
	CONSTRAINT [DF_U_STO_TS_Indiriz] DEFAULT ('') FOR [Indiriz],
	CONSTRAINT [DF_U_STO_TS_Cap] DEFAULT ('') FOR [Cap],
	CONSTRAINT [DF_U_STO_TS_ComuneInd] DEFAULT ('') FOR [ComuneInd],
	CONSTRAINT [DF_U_STO_TS_Piva] DEFAULT ('') FOR [Piva],
	CONSTRAINT [DF_U_STO_TS_CdFisc] DEFAULT ('') FOR [CdFisc],
	CONSTRAINT [DF_U_STO_TS_Email_AnaAzi] DEFAULT ('') FOR [Email_AnaAzi],
	CONSTRAINT [DF_U_STO_TS_SitoWeb] DEFAULT ('') FOR [SitoWeb],
	CONSTRAINT [DF_U_STO_TS_Telefono] DEFAULT ('') FOR [Telefono],
	CONSTRAINT [DF_U_STO_TS_Fax] DEFAULT ('') FOR [Fax],
	CONSTRAINT [DF_U_STO_TS_B_PerFis] DEFAULT ('') FOR [B_PerFis],
	CONSTRAINT [DF_U_STO_TS_B_Client] DEFAULT ('') FOR [B_Client],
	CONSTRAINT [DF_U_STO_TS_B_Fornit] DEFAULT ('') FOR [B_Fornit],
	CONSTRAINT [DF_U_STO_TS_B_SocPro] DEFAULT ('') FOR [B_SocPro],
	CONSTRAINT [DF_U_STO_TS_B_SocGrp] DEFAULT ('') FOR [B_SocGrp],
	CONSTRAINT [DF_U_STO_TS_B_IntGrp] DEFAULT ('') FOR [B_IntGrp],
	CONSTRAINT [DF_U_STO_TS_IDTitolo] DEFAULT ('') FOR [IDTitolo]

GO



--*** AGGIORNAMENTO TABELLA "U_CLI_AN"
--------------------------------------
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_CLI_AN] ADD 
	 IDAnaAzi varchar(32) COLLATE Latin1_General_CI_AS NULL,
	 Codice varchar(16) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_CLI_AN] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_CLI_AN_IDAnaAzi] DEFAULT ('') FOR [IDAnaAzi],
	CONSTRAINT [DF_U_CLI_AN_Codice] DEFAULT ('') FOR [Codice]
go

UPDATE U_CLI_AN SET IDAnaAzi = ''
UPDATE U_CLI_AN SET Codice = ''



--*** AGGIORNAMENTO TABELLA "U_FOR_AN"
--------------------------------------
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_FOR_AN] ADD 
	 IDAnaAzi varchar(32) COLLATE Latin1_General_CI_AS NULL,
	 Codice varchar(16) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_FOR_AN] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_FOR_AN_IDAnaAzi] DEFAULT ('') FOR [IDAnaAzi],
	CONSTRAINT [DF_U_FOR_AN_Codice] DEFAULT ('') FOR [Codice]
go

UPDATE U_FOR_AN SET IDAnaAzi = ''
UPDATE U_FOR_AN SET Codice = ''


