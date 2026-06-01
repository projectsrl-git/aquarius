
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[AQ_RAP]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[AQ_RAP]
GO

CREATE TABLE [dbo].[AQ_RAP](
	[id_unique] uniqueidentifier ROWGUIDCOL NOT NULL CONSTRAINT [DF_AQ_RAP_id_unique] DEFAULT newid(),
	[ID_RAP] [int] IDENTITY(1,1) NOT NULL,
	[NumPro] varchar(10) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_AQ_RAP_NumPro] DEFAULT (''),
	[IDScadenza] varchar(10) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_AQ_RAP_IDScadenza] DEFAULT (''),
	[IDdocumento] varchar(10) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_AQ_RAP_IDdocumento] DEFAULT (''),
	[Status] varchar(1) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_AQ_RAP_Status] DEFAULT (''),
	[NumeroDoc] varchar(25) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_AQ_RAP_NumeroDoc] DEFAULT (''),
	[DataDoc] varchar(10) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_AQ_RAP_DataDoc] DEFAULT (''),
	[CodiceANA] varchar(10) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_AQ_RAP_CodiceANA] DEFAULT (''),
	[DataPagamento] varchar(10) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_AQ_RAP_DataPagamento] DEFAULT (''),
	[CodiceRAP] varchar(4) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_AQ_RAP_CodiceRAP] DEFAULT (''),
	[SubCodiceRAP] varchar(4) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_AQ_RAP_SubCodiceRAP] DEFAULT (''),
	[TotaleParcella] numeric(19,2) NOT NULL CONSTRAINT [DF_AQ_RAP_TotaleParcella] DEFAULT (0),
	[AliquotaRAP] numeric(19,2) NOT NULL CONSTRAINT [DF_AQ_RAP_AliquotaRAP] DEFAULT (0),
	[ImportoRAP] numeric(19,2) NOT NULL CONSTRAINT [DF_AQ_RAP_ImportoRAP] DEFAULT (0),
	[SoggettoRAP] numeric(19,2) NOT NULL CONSTRAINT [DF_AQ_RAP_SoggettoRAP] DEFAULT (0),
	[NonSoggettoRAP] numeric(19,2) NOT NULL CONSTRAINT [DF_AQ_RAP_NonSoggettoRAP] DEFAULT (0),
	[ImportoAnticipazioni] numeric(19,2) NOT NULL CONSTRAINT [DF_AQ_RAP_ImportoAnticipazioni] DEFAULT (0),
	[ImportoPrevidenza] numeric(19,2) NOT NULL CONSTRAINT [DF_AQ_RAP_ImportoPrevidenza] DEFAULT (0),
	[ImportoBolli] numeric(19,2) NOT NULL CONSTRAINT [DF_AQ_RAP_ImportoBolli] DEFAULT (0),
	[SoggettoIVA] numeric(19,2) NOT NULL CONSTRAINT [DF_AQ_RAP_SoggettoIVA] DEFAULT (0),
	[NonSoggettoIVA] numeric(19,2) NOT NULL CONSTRAINT [DF_AQ_RAP_NonSoggettoIVA] DEFAULT (0),
	[ImportoIVA] numeric(19,2) NOT NULL CONSTRAINT [DF_AQ_RAP_ImportoIVA] DEFAULT (0),
	[StampatoF24] bit NOT NULL CONSTRAINT [DF_AQ_RAP_StampatoF24] DEFAULT (0),
	[StampatoCertificazione] bit NOT NULL CONSTRAINT [DF_AQ_RAP_StampatoCertificazione] DEFAULT (0),
	[QuotaINPS_Percipiente] numeric(19,2) NOT NULL CONSTRAINT [DF_AQ_RAP_QuotaINPS_Percipiente] DEFAULT (0),
	[ValutaDocumento] varchar(3) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_AQ_RAP_ValutaDocumento] DEFAULT (0),
	[ValutaPagamento] varchar(3) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_AQ_RAP_ValutaPagamento] DEFAULT (0),
	[INPS_Totale] numeric(19,2) NOT NULL CONSTRAINT [DF_AQ_RAP_INPS_Totale] DEFAULT (0),
	[QuotaINPS_Committente] numeric(19,2) NOT NULL CONSTRAINT [DF_AQ_RAP_QuotaINPS_Committente] DEFAULT (0)
) ON [PRIMARY]
GO
