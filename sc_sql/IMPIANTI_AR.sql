

/****** Object:  Table [dbo].[IMPIANTI_AR]   ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[IMPIANTI_AR]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[IMPIANTI_AR]
GO  
        
 
CREATE TABLE [dbo].[IMPIANTI_AR](
	[id_unique]  uniqueidentifier ROWGUIDCOL  NOT NULL CONSTRAINT [DF_IMPIANTI_AR_id_unique] DEFAULT (newid()),
	[CODICE]        	[varchar](10) NULL CONSTRAINT [DF_IMPIANTI_AR_CODICE] DEFAULT (''),
	[COGNOME]        	[varchar](100) NULL CONSTRAINT [DF_IMPIANTI_AR_COGNOME] DEFAULT (''),
	[NOME]        		[varchar](100) NULL CONSTRAINT [DF_IMPIANTI_AR_NOME] DEFAULT (''),            
	[GIURIDICA]        	[Numeric](2) NULL, 	
	[COD_FISC]         	[varchar](16) NULL CONSTRAINT [DF_IMPIANTI_AR_COD_FISC] DEFAULT (''),            
	[P_IVA]				[varchar](11) NULL CONSTRAINT [DF_IMPIANTI_AR_P_IVA] DEFAULT (''),            
	[DOMIC_FISC]      	[varchar](40) NULL CONSTRAINT [DF_IMPIANTI_AR_DOMIC_FISC] DEFAULT (''), 
	[LOCALITA_F]     	[varchar](40) NULL CONSTRAINT [DF_IMPIANTI_AR_LOCALITA_F] DEFAULT (''), 
	[CAP_F]				[varchar](5) NULL CONSTRAINT [DF_IMPIANTI_AR_CAP_F] DEFAULT (''), 
	[PROV_F]      		[varchar](4) NULL CONSTRAINT [DF_IMPIANTI_AR_PROV_F] DEFAULT (''), 
	[TELEFONO]      	[varchar](40) NULL CONSTRAINT [DF_IMPIANTI_AR_OTELEFONO] DEFAULT ('')           
) 

ALTER TABLE [dbo].[IMPIANTI_AR] WITH NOCHECK ADD 
	CONSTRAINT [PK_IMPIANTI_AR] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO
