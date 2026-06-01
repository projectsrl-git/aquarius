

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PIANOP_MO]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[PIANOP_MO]
GO
 
CREATE TABLE [dbo].[PIANOP_MO] (
	[id_unique]  uniqueidentifier ROWGUIDCOL  NOT NULL ,
	[daggancio] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
		[SELEZIONE]  	[varchar] (3)  COLLATE Latin1_General_CI_AS NULL,
		[ID_MOVIMEN] 	[varchar] (120) COLLATE Latin1_General_CI_AS NULL,
		[CODRIS_DA]	[varchar] (20) COLLATE Latin1_General_CI_AS NULL,
		[CODRIS_A]		[varchar] (20) COLLATE Latin1_General_CI_AS NULL,
		[DES_DA]		[varchar] (50) COLLATE Latin1_General_CI_AS NULL,
		[DES_A]		[varchar] (50) COLLATE Latin1_General_CI_AS NULL,
		[CODCAUSALE] 	[varchar] (20) COLLATE Latin1_General_CI_AS NULL,
		[DES_MOVIME]	[varchar] (30) COLLATE Latin1_General_CI_AS NULL,
		[IMPORTO]	    [numeric] (17,3) NULL,
		[DT_DISPON]	    [varchar] (10)   COLLATE Latin1_General_CI_AS NULL,
		[DT_CONTAB]	    [varchar] (10)   COLLATE Latin1_General_CI_AS NULL,
		[COD_USER]	    [varchar] (20)   COLLATE Latin1_General_CI_AS NULL,
		[NPART] 	    [numeric] (10,0) NULL, 
		[DTREG] 	    [varchar] (10)	COLLATE Latin1_General_CI_AS NULL,
		[tipopagam]     [varchar] (3)	COLLATE Latin1_General_CI_AS NULL,
	        [tipologia]     [varchar] (20)	COLLATE Latin1_General_CI_AS NULL,
		[cosatratta]    [varchar] (5)	COLLATE Latin1_General_CI_AS NULL,
		[gradoimpor]    [varchar] (5)	COLLATE Latin1_General_CI_AS NULL,
		[formapagam]    [varchar] (5)	COLLATE Latin1_General_CI_AS NULL,
		[tipocontra]    [varchar] (5)	COLLATE Latin1_General_CI_AS NULL,
		[codacq]    [varchar] (3)	COLLATE Latin1_General_CI_AS NULL,
		[pripaga]    [varchar] (4)	COLLATE Latin1_General_CI_AS NULL,
		[dtscad]    [varchar] (10)	COLLATE Latin1_General_CI_AS NULL,
		[codfor]    [varchar] (13)	COLLATE Latin1_General_CI_AS NULL,
		[banca]    [varchar] (10)	COLLATE Latin1_General_CI_AS NULL,
		[contocorr]    [varchar] (20)	COLLATE Latin1_General_CI_AS NULL,
		[contocont]    [varchar] (13)	COLLATE Latin1_General_CI_AS NULL,
		[quantavalu]    [numeric] (17,3) NULL,
		[quandovalu]    [varchar] (10)	COLLATE Latin1_General_CI_AS NULL,
		[ABI]		    [varchar] (5)	COLLATE Latin1_General_CI_AS NULL,
		[CAB] 		    [varchar] (5) COLLATE Latin1_General_CI_AS NULL,
		[CIN] 		    [varchar] (3) COLLATE Latin1_General_CI_AS NULL,
		[PREVIS]	    [varchar] (1) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[PIANOP_MO] WITH NOCHECK ADD 
	CONSTRAINT [PK_PIANOP_MO] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[PIANOP_MO] WITH NOCHECK ADD 
	CONSTRAINT [DF_PIANOP_MO_id_unique] DEFAULT (newid()) FOR [id_unique],
    CONSTRAINT [DF_PIANOP_MO_SELEZIONE] DEFAULT ('') FOR [SELEZIONE]  	, 	
    CONSTRAINT [DF_PIANOP_MO_ID_MOVIMEN] DEFAULT ('') FOR [ID_MOVIMEN] 	  	,
    CONSTRAINT [DF_PIANOP_MO_CODRIS_DA]	DEFAULT ('') FOR [CODRIS_DA]	,   
    CONSTRAINT [DF_PIANOP_MO_CODRIS_A]	DEFAULT ('') FOR [CODRIS_A]		,   	
    CONSTRAINT [DF_PIANOP_MO_DES_DA]	DEFAULT ('') FOR [DES_DA]		    , 	
    CONSTRAINT [DF_PIANOP_MO_DES_A]	DEFAULT ('') FOR [DES_A]		,     	
    CONSTRAINT [DF_PIANOP_MO_CODCAUSALE] DEFAULT ('') FOR [CODCAUSALE] 	  	,
    CONSTRAINT [DF_PIANOP_MO_DES_MOVIME]	DEFAULT ('') FOR [DES_MOVIME]	,   
    CONSTRAINT [DF_PIANOP_MO_IMPORTO]	DEFAULT (0) FOR [IMPORTO]	        , 
    CONSTRAINT [DF_PIANOP_MO_DT_DISPON]	DEFAULT ('') FOR [DT_DISPON]	    ,   
    CONSTRAINT [DF_PIANOP_MO_DT_CONTAB]	DEFAULT ('') FOR [DT_CONTAB]	    ,   
    CONSTRAINT [DF_PIANOP_MO_COD_USER]	DEFAULT ('') FOR [COD_USER]	    ,   
    CONSTRAINT [DF_PIANOP_MO_NPART] 	    DEFAULT (0) FOR [NPART] 	    ,   
    CONSTRAINT [DF_PIANOP_MO_DTREG] 	    DEFAULT ('') FOR [DTREG] 	    ,   
    CONSTRAINT [DF_PIANOP_MO_tipopagam]  DEFAULT ('') FOR [tipopagam]       ,
    CONSTRAINT [DF_PIANOP_MO_tipologia]  DEFAULT ('') FOR [tipologia]       ,
    CONSTRAINT [DF_PIANOP_MO_cosatratta] DEFAULT ('') FOR [cosatratta]      ,
    CONSTRAINT [DF_PIANOP_MO_gradoimpor] DEFAULT ('') FOR [gradoimpor]      ,
    CONSTRAINT [DF_PIANOP_MO_formapagam] DEFAULT ('') FOR [formapagam]      ,
    CONSTRAINT [DF_PIANOP_MO_tipocontra] DEFAULT ('') FOR [tipocontra]      ,
    CONSTRAINT [DF_PIANOP_MO_codacq] DEFAULT ('') FOR [codacq]      ,
    CONSTRAINT [DF_PIANOP_MO_pripaga] DEFAULT ('') FOR [pripaga]      ,
    CONSTRAINT [DF_PIANOP_MO_dtscad] DEFAULT ('') FOR [dtscad]      ,
    CONSTRAINT [DF_PIANOP_MO_codfor] DEFAULT ('') FOR [codfor]      ,
    CONSTRAINT [DF_PIANOP_MO_banca] DEFAULT ('') FOR [banca]    ,  
    CONSTRAINT [DF_PIANOP_MO_contocorr] DEFAULT ('') FOR [contocorr]      ,
    CONSTRAINT [DF_PIANOP_MO_contocont] DEFAULT ('') FOR [contocont]      ,
    CONSTRAINT [DF_PIANOP_MO_quantavalu] DEFAULT (0) FOR [quantavalu]      ,
    CONSTRAINT [DF_PIANOP_MO_quandovalu] DEFAULT ('') FOR [quandovalu]      ,
    CONSTRAINT [DF_PIANOP_MO_ABI]		DEFAULT ('') FOR [ABI]		        ,    
    CONSTRAINT [DF_PIANOP_MO_CAB] 		DEFAULT ('') FOR [CAB] 		        ,   
    CONSTRAINT [DF_PIANOP_MO_CIN] 		DEFAULT ('') FOR [CIN] 		        ,   
    CONSTRAINT [DF_PIANOP_MO_PREVIS]	    DEFAULT ('') FOR [PREVIS]	       	
GO

