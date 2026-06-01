if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PIANOP_P2]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[PIANOP_P2]
GO
 
CREATE TABLE [dbo].[PIANOP_P2] (
	[id_unique]  uniqueidentifier ROWGUIDCOL  NOT NULL ,
	[daggancio] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[SELEZIONE]		[varchar] (3)	COLLATE Latin1_General_CI_AS NULL, 
	[LEGA_SPLIT]		[varchar] (30)	COLLATE Latin1_General_CI_AS NULL, 
	[ID_PARTITA] 		[varchar] (120)	COLLATE Latin1_General_CI_AS NULL, 
	[tipologia]		[varchar] (20)	COLLATE Latin1_General_CI_AS NULL, 
	[ragsoc]		[varchar] (30)	COLLATE Latin1_General_CI_AS NULL, 
	[contabilit]		[varchar] (1)	COLLATE Latin1_General_CI_AS NULL,   	      	
	[npart]		[numeric] (10,0)	NULL,  	    
	[dtscad]		[varchar] (10)	COLLATE Latin1_General_CI_AS NULL, 			
	[nsaldo]		[numeric] (17,3)	NULL,		
	[ndare]		[numeric] (17,3)	NULL,		
	[navere]		[numeric] (17,3)	NULL,		
	[codfor]		[varchar] (13)	COLLATE Latin1_General_CI_AS NULL, 			
	[tipopagam]		[varchar] (3)	COLLATE Latin1_General_CI_AS NULL, 			
	[cosatratta]		[varchar] (5)	COLLATE Latin1_General_CI_AS NULL, 			
	[gradoimpor]		[varchar] (5)	COLLATE Latin1_General_CI_AS NULL, 			
	[formapagam]		[varchar] (5)	COLLATE Latin1_General_CI_AS NULL, 			
	[tipocontra]		[varchar] (5)	COLLATE Latin1_General_CI_AS NULL, 			
	[codacq]		[varchar] (3)	COLLATE Latin1_General_CI_AS NULL, 			
	[pripaga]		[varchar] (4)	COLLATE Latin1_General_CI_AS NULL, 			
	[banca]		[varchar] (10)	COLLATE Latin1_General_CI_AS NULL, 			
	[contocorr]		[varchar] (20)	COLLATE Latin1_General_CI_AS NULL, 			
	[contocont]		[varchar] (13)	COLLATE Latin1_General_CI_AS NULL, 			
	[quantavalu]		[numeric] (17,3)	NULL, 		
	[quandovalu]		[varchar] (10)	COLLATE Latin1_General_CI_AS NULL, 
	[ANOMALIA]		[varchar] (3)	COLLATE Latin1_General_CI_AS NULL
		
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[PIANOP_P2] WITH NOCHECK ADD 
	CONSTRAINT [PK_PIANOP_P2] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[PIANOP_P2] WITH NOCHECK ADD 
	CONSTRAINT [DF_PIANOP_P2_id_unique] DEFAULT (newid()) FOR [id_unique],
	CONSTRAINT [DF_PIANOP_P2_SELEZIONE]  DEFAULT ('') FOR [SELEZIONE],
	CONSTRAINT [DF_PIANOP_P2_LEGA_SPLIT]  DEFAULT ('') FOR [LEGA_SPLIT],
	CONSTRAINT [DF_PIANOP_P2_ID_PARTITA]  DEFAULT ('') FOR [ID_PARTITA], 
	CONSTRAINT [DF_PIANOP_P2_tipologia]  DEFAULT ('') FOR [tipologia], 
	CONSTRAINT [DF_PIANOP_P2_ragsoc]  DEFAULT ('') FOR [ragsoc],    
	CONSTRAINT [DF_PIANOP_P2_contabilit]  DEFAULT ('') FOR [contabilit],
	CONSTRAINT [DF_PIANOP_P2_npart]  DEFAULT (0) FOR [npart],
	CONSTRAINT [DF_PIANOP_P2_dtscad]  DEFAULT ('') FOR [dtscad],
	CONSTRAINT [DF_PIANOP_P2_nsaldo]  DEFAULT (0) FOR  [nsaldo], 
	CONSTRAINT [DF_PIANOP_P2_navere]  DEFAULT (0) FOR  [navere],
	CONSTRAINT [DF_PIANOP_P2_codfor]  DEFAULT ('') FOR  [codfor]
GO                               