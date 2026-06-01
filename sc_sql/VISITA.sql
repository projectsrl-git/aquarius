	
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[VISITA]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[VISITA]
GO

/****** Object:  Table [dbo].[VISITA]    Script Date: 28/09/2007 9.53.01 ******/
CREATE TABLE [VISITA] (
	id_unique  uniqueidentifier ROWGUIDCOL  NOT NULL ,
	[DAGGANCIO] 	[varchar] (32) COLLATE Latin1_General_CI_AS NULL ,
	[IDVISITA] 		[varchar] (32) COLLATE Latin1_General_CI_AS NOT NULL ,
	[IDCONTATTOV] 	[varchar] (32) COLLATE Latin1_General_CI_AS NULL ,
	[D_VISITA] 		[varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[ORAV] 			[varchar] (5) COLLATE Latin1_General_CI_AS NULL ,
	[OGGETTOV] 		[varchar] (255) COLLATE Latin1_General_CI_AS NULL ,
	[ESITOV] 		[text] COLLATE Latin1_General_CI_AS NULL ,
	[ORDINEV]   	[numeric] (3, 0) NULL  

) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO


ALTER TABLE [dbo].[VISITA] WITH NOCHECK ADD 
	CONSTRAINT [PK_VISITA] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[VISITA] WITH NOCHECK ADD 
	CONSTRAINT [DF_VISITA_id_unique] 		DEFAULT (newid()) FOR 			[id_unique],
	CONSTRAINT [DF_VISITA_DAGGANCIO]   	DEFAULT ('') FOR 				[DAGGANCIO] ,	
	CONSTRAINT [DF_VISITA_IDVISITA]     	DEFAULT ('') FOR 				[IDVISITA] ,
	CONSTRAINT [DF_VISITA_IDCONTATTOV]    	DEFAULT ('') FOR 				[IDCONTATTOV],
	CONSTRAINT [DF_VISITA_D_VISITA] 	  	   	DEFAULT ('') FOR 			[D_VISITA] 	  ,
	CONSTRAINT [DF_VISITA_ORAV] 	  	   	DEFAULT ('') FOR 				[ORAV] 	  ,
	CONSTRAINT [DF_VISITA_OGGETTOV] 	    		DEFAULT ('') FOR 		[OGGETTOV]   ,   
	CONSTRAINT [DF_VISITA_ESITOV] 		   	      	   	DEFAULT ('') FOR 	[ESITOV] 	     ,   
	CONSTRAINT [DF_VISITA_ORDINEV] 	  	       	   	DEFAULT (0) FOR 	[ORDINEV] 	       
        
                                                                                         
                                                  
GO                                                




  