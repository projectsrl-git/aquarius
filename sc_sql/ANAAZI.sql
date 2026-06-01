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

