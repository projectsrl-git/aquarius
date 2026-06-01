	
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[TELEFON]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[TELEFON]
GO

/****** Object:  Table [dbo].[TELEFON]    Script Date: 28/09/2007 9.53.01 ******/
CREATE TABLE [TELEFON] (
	id_unique  uniqueidentifier ROWGUIDCOL  NOT NULL ,
	[DAGGANCIO] 	[varchar] (32) COLLATE Latin1_General_CI_AS NULL ,
	[IDTELEFON] 	[varchar] (32) COLLATE Latin1_General_CI_AS NOT NULL ,
	[IDCONTATTO] 	[varchar] (32) COLLATE Latin1_General_CI_AS NULL ,
	[D_TELEFON] 	[varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[ORA] 			[varchar] (5) COLLATE Latin1_General_CI_AS NULL ,
	[OGGETTO] 		[varchar] (255) COLLATE Latin1_General_CI_AS NULL ,
	[ESITO] 			[text] COLLATE Latin1_General_CI_AS NULL ,
	[ORDINE]   		[numeric] (3, 0) NULL  

) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO


ALTER TABLE [dbo].[TELEFON] WITH NOCHECK ADD 
	CONSTRAINT [PK_TELEFON] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[TELEFON] WITH NOCHECK ADD 
	CONSTRAINT [DF_TELEFON_id_unique] 		DEFAULT (newid()) FOR 			[id_unique],
	CONSTRAINT [DF_TELEFON_DAGGANCIO]   	DEFAULT ('') FOR 				[DAGGANCIO] ,	
	CONSTRAINT [DF_TELEFON_IDTELEFON]     	DEFAULT ('') FOR 				[IDTELEFON] ,
	CONSTRAINT [DF_TELEFON_IDCONTATTO]    	DEFAULT ('') FOR 				[IDCONTATTO],
	CONSTRAINT [DF_TELEFON_D_TELEFON] 	  	   	DEFAULT ('') FOR 			[D_TELEFON] 	  ,
	CONSTRAINT [DF_TELEFON_ORA] 	  	   	DEFAULT ('') FOR 				[ORA] 	  ,
	CONSTRAINT [DF_TELEFON_OGGETTO] 	    		DEFAULT ('') FOR 		[OGGETTO]   ,   
	CONSTRAINT [DF_TELEFON_ESITO] 		   	      	   	DEFAULT ('') FOR 	[ESITO] 	     ,   
	CONSTRAINT [DF_TELEFON_ORDINE] 	  	       	   	DEFAULT (0) FOR 		[ORDINE] 	       
        
                                                                                         
                                                  
GO                                                




  