	
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CONTATTO]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[CONTATTO]
GO

/****** Object:  Table [dbo].[CONTATTO]    Script Date: 28/09/2007 9.53.01 ******/
CREATE TABLE [CONTATTO] (
	id_unique  uniqueidentifier ROWGUIDCOL  NOT NULL ,
	[TAGGANCIO] 	[varchar] (32) COLLATE Latin1_General_CI_AS NULL ,
	[IDCONTATTO] 	[varchar] (32) COLLATE Latin1_General_CI_AS NOT NULL ,
	[IDCENTRCOM] 	[varchar] (32) COLLATE Latin1_General_CI_AS NULL ,
	[IDLOCNASCIT] 	[varchar] (32) COLLATE Latin1_General_CI_AS NULL ,
	[IDLOCRESID] 	[varchar] (32) COLLATE Latin1_General_CI_AS NULL ,
	[IDCONOSCEN] 	[varchar] (32) COLLATE Latin1_General_CI_AS NULL ,
	[COGNOME] 		[varchar] (100) COLLATE Latin1_General_CI_AS NULL ,
	[NOME] 			[varchar] (50) COLLATE Latin1_General_CI_AS NULL ,
	[SESSO] 		[varchar] (1) COLLATE Latin1_General_CI_AS NULL ,
	[D_NASCITA] 	[varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[LOCNASCITA] 	[varchar] (120) COLLATE Latin1_General_CI_AS NULL ,
	[CODFISCALE] 	[varchar] (16) COLLATE Latin1_General_CI_AS NULL ,
	[PARTITAIVA] 	[varchar] (11) COLLATE Latin1_General_CI_AS NULL ,
	[INDIRIZZO] 	[varchar] (255) COLLATE Latin1_General_CI_AS NULL ,
	[CAP] 			[varchar] (5) COLLATE Latin1_General_CI_AS NULL ,
	[LOCRESIDENZ] 	[varchar] (120) COLLATE Latin1_General_CI_AS NULL ,
	[TITSTUDIO] 	[varchar] (255) COLLATE Latin1_General_CI_AS NULL ,
	[TELEFONO] 		[varchar] (30) COLLATE Latin1_General_CI_AS NULL ,
	[CELLULARE] 	[varchar] (30) COLLATE Latin1_General_CI_AS NULL ,
	[EMAIL] 		[varchar] (120) COLLATE Latin1_General_CI_AS NULL ,
	[PREFEVENINC] 	[text] COLLATE Latin1_General_CI_AS NULL ,
	[ANNOTAZIONI] 	[text] COLLATE Latin1_General_CI_AS NULL ,
	[PREFALTCORS] 	[varchar] (255) COLLATE Latin1_General_CI_AS NULL ,
	[B_CONTRAEN] 	[varchar] (1) COLLATE Latin1_General_CI_AS NOT NULL ,
	[UTENTEINS] 	[varchar] (50) COLLATE Latin1_General_CI_AS NULL ,
	[D_DATAINS] 	[varchar] (14) COLLATE Latin1_General_CI_AS NULL ,
	[UTENTEMOD] 	[varchar] (50) COLLATE Latin1_General_CI_AS NULL ,
	[D_DATAMOD] 	[varchar] (14) COLLATE Latin1_General_CI_AS NULL 

) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO


ALTER TABLE [dbo].[CONTATTO] WITH NOCHECK ADD 
	CONSTRAINT [PK_CONTATTO] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[CONTATTO] WITH NOCHECK ADD 
	CONSTRAINT [DF_CONTATTO_id_unique] 		DEFAULT (newid()) FOR 			[id_unique],
	CONSTRAINT [DF_CONTATTO_TAGGANCIO] 	  	DEFAULT ('') FOR 				[TAGGANCIO] ,	
	CONSTRAINT [DF_CONTATTO_IDCONTATTO] 	    	DEFAULT ('') FOR 		[IDCONTATTO] ,
	CONSTRAINT [DF_CONTATTO_IDCENTRCOM] 	    	DEFAULT ('') FOR 		[IDCENTRCOM] ,
	CONSTRAINT [DF_CONTATTO_IDLOCNASCIT] 	   	DEFAULT ('') FOR 			[IDLOCNASCIT],
	CONSTRAINT [DF_CONTATTO_IDLOCRESID] 	    	DEFAULT ('') FOR 		[IDLOCRESID] ,
	CONSTRAINT [DF_CONTATTO_IDCONOSCEN] 	   		DEFAULT ('') FOR 		[IDCONOSCEN] ,   
	CONSTRAINT [DF_CONTATTO_COGNOME] 		      	   	DEFAULT ('') FOR 	[COGNOME] 	  ,   
	CONSTRAINT [DF_CONTATTO_NOME] 			       	   	DEFAULT ('') FOR 	[NOME] 		    ,   
	CONSTRAINT [DF_CONTATTO_SESSO] 		        	DEFAULT ('') FOR 		[SESSO] 		   ,  
	CONSTRAINT [DF_CONTATTO_D_NASCITA] 	          DEFAULT ('') FOR 			[D_NASCITA] 	,    
	CONSTRAINT [DF_CONTATTO_LOCNASCITA] 	   	   	DEFAULT ('') FOR 		[LOCNASCITA] ,   
	CONSTRAINT [DF_CONTATTO_CODFISCALE] 	  	 	DEFAULT ('') FOR 		[CODFISCALE] , 
	CONSTRAINT [DF_CONTATTO_PARTITAIVA] 	 	   	DEFAULT ('') FOR 		[PARTITAIVA] ,  
	CONSTRAINT [DF_CONTATTO_INDIRIZZO] 	    	   	DEFAULT ('') FOR 		[INDIRIZZO] 	,   
	CONSTRAINT [DF_CONTATTO_CAP] 			       	  	DEFAULT ('') FOR 	[CAP] 		     , 
	CONSTRAINT [DF_CONTATTO_LOCRESIDENZ] 	   	DEFAULT ('') FOR 			[LOCRESIDENZ],  
	CONSTRAINT [DF_CONTATTO_TITSTUDIO] 	     	DEFAULT ('') FOR 			[TITSTUDIO] 	,  
	CONSTRAINT [DF_CONTATTO_TELEFONO] 		     	DEFAULT ('') FOR 		[TELEFONO] 	 ,  
	CONSTRAINT [DF_CONTATTO_CELLULARE] 	     	DEFAULT ('') FOR 			[CELLULARE] 	,  
    CONSTRAINT [DF_CONTATTO_EMAIL] 		              DEFAULT ('') FOR      [EMAIL] 	    ,
    CONSTRAINT [DF_CONTATTO_PREFEVENINC] 	          DEFAULT ('') FOR      [PREFEVENINC]    ,
    CONSTRAINT [DF_CONTATTO_ANNOTAZIONI] 	          DEFAULT ('') FOR      [ANNOTAZIONI]     ,
    CONSTRAINT [DF_CONTATTO_PREFALTCORS] 	          DEFAULT ('') FOR      [PREFALTCORS]      ,
    CONSTRAINT [DF_CONTATTO_B_CONTRAEN] 	          DEFAULT ('') FOR      [B_CONTRAEN]  	 ,
    CONSTRAINT [DF_CONTATTO_UTENTEINS] 	              DEFAULT ('') FOR      [UTENTEINS] 	 	 ,
    CONSTRAINT [DF_CONTATTO_D_DATAINS] 	              DEFAULT ('') FOR      [D_DATAINS] 	 	 ,
    CONSTRAINT [DF_CONTATTO_UTENTEMOD] 	              DEFAULT ('') FOR      [UTENTEMOD] 	 	 ,
    CONSTRAINT [DF_CONTATTO_D_DATAMOD] 	              DEFAULT ('') FOR      [D_DATAMOD] 	                
                                                                                         
                                                  
GO                                                




  