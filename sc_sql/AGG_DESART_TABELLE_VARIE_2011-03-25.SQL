
/* 
**************************************************************
MODIFICA AI CAMPI DELLE TABELLA U_ART_PR
**************************************************************
*/

ALTER TABLE [dbo].[U_ART_PR] ALTER COLUMN
	 [ART_DESCR] varchar (254) NULL
go
ALTER TABLE [dbo].[U_ART_PR] ALTER COLUMN
 	 [ART_DESEST] varchar (254) NULL
 	 

/* 
**************************************************************
MODIFICA AI CAMPI DELLE TABELLA U_FAT_DD
**************************************************************
*/

go
ALTER TABLE [dbo].[U_FAT_DD] ALTER COLUMN
 	 [ORD_DESART] varchar (254) NULL
go
ALTER TABLE [dbo].[U_FAT_DD] ALTER COLUMN
 	 [ORD_DES2] varchar (254) NULL
go


/* 
**************************************************************
MODIFICA AI CAMPI DELLE TABELLA U_FAP_DD
**************************************************************
*/

go
ALTER TABLE [dbo].[U_FAP_DD] ALTER COLUMN
 	 [ORD_DESART] varchar (254) NULL
go
ALTER TABLE [dbo].[U_FAP_DD] ALTER COLUMN
 	 [ORD_DES2] varchar (254) NULL
go


 	 
/* 
**************************************************************
MODIFICA AI CAMPI DELLE TABELLA U_ORD_DD
**************************************************************
*/

go
ALTER TABLE [dbo].[U_ORD_DD] ALTER COLUMN
 	 [ORD_DESART] varchar (100) NULL
go
ALTER TABLE [dbo].[U_ORD_DD] ALTER COLUMN
 	 [ORD_DES2] varchar (100) NULL
go



/* 
**************************************************************
MODIFICA AI CAMPI DELLE TABELLA U_ORF_DD
**************************************************************
*/

go
ALTER TABLE [dbo].[U_ORF_DD] ALTER COLUMN
 	 [ORD_DESART] varchar (100) NULL
go
ALTER TABLE [dbo].[U_ORF_DD] ALTER COLUMN
 	 [ORD_DES2] varchar (100) NULL
go



/* 
**************************************************************
MODIFICA AI CAMPI DELLE TABELLA U_OFF_DD
**************************************************************
*/

go
ALTER TABLE [dbo].[U_OFF_DD] ALTER COLUMN
 	 [ORD_DESART] varchar (100) NULL
go
ALTER TABLE [dbo].[U_OFF_DD] ALTER COLUMN
 	 [ORD_DES2] varchar (100) NULL
go



/* 
**************************************************************
MODIFICA AI CAMPI DELLE TABELLA U_BFO_DD
**************************************************************
*/

go
ALTER TABLE [dbo].[U_BFO_DD] ALTER COLUMN
 	 [ORD_DESART] varchar (100) NULL
go
ALTER TABLE [dbo].[U_BFO_DD] ALTER COLUMN
 	 [ORD_DES2] varchar (100) NULL
go

/* 
**************************************************************
MODIFICA AI CAMPI DELLE TABELLA U_BFO_DL
**************************************************************
*/

ALTER TABLE [dbo].[U_BFO_DL] ALTER COLUMN
 	 [ORD_DESART] varchar (100) NULL
go





/* 
**************************************************************
MODIFICA AI CAMPI DELLE TABELLA U_PCK_DD
**************************************************************
*/

go
ALTER TABLE [dbo].[U_PCK_DD] ALTER COLUMN
 	 [ORD_DESART] varchar (100) NULL
go
ALTER TABLE [dbo].[U_PCK_DD] ALTER COLUMN
 	 [ORD_DES2] varchar (100) NULL
go

/* 
**************************************************************
MODIFICA AI CAMPI DELLE TABELLA U_BFO_DL
**************************************************************
*/

ALTER TABLE [dbo].[U_PCK_LE] ALTER COLUMN
 	 [LEG_DESART] varchar (100) NULL
go





/* 
**************************************************************
MODIFICA AI CAMPI DELLE TABELLA U_BOL_DD
**************************************************************
*/

go
ALTER TABLE [dbo].[U_BOL_DD] ALTER COLUMN
 	 [ORD_DESART] varchar (100) NULL
go
ALTER TABLE [dbo].[U_BOL_DD] ALTER COLUMN
 	 [ORD_DES2] varchar (100) NULL
go

/* 
**************************************************************
MODIFICA AI CAMPI DELLE TABELLA U_BOL_LE
**************************************************************
*/

ALTER TABLE [dbo].[U_BOL_LE] ALTER COLUMN
 	 [LEG_DESART] varchar (100) NULL
go








/* 
**************************************************************
MODIFICA AI CAMPI DELLE TABELLA L_BOL_DD
**************************************************************
*/

go
ALTER TABLE [dbo].[L_BOL_DD] ALTER COLUMN
 	 [ORD_DESART] varchar (100) NULL
go
ALTER TABLE [dbo].[L_BOL_DD] ALTER COLUMN
 	 [ORD_DES2] varchar (100) NULL
go

/* 
**************************************************************
MODIFICA AI CAMPI DELLE TABELLA L_BOL_LE
**************************************************************
*/

ALTER TABLE [dbo].[L_BOL_LE] ALTER COLUMN
 	 [LEG_DESART] varchar (100) NULL
go



/* 
**************************************************************
MODIFICA AI CAMPI DELLE TABELLA U_LIS_TT
**************************************************************
*/

ALTER TABLE [dbo].[U_LIS_TT] ALTER COLUMN
 	 [LIS_DESART] varchar (100) NULL
go




/* 
**************************************************************
MODIFICA AI CAMPI DELLE TABELLA  U_STC_AN
**************************************************************
*/

ALTER TABLE [dbo].[U_STC_AN] ALTER COLUMN
 	 [STC_DESART] varchar (100) NULL
go


/* 
**************************************************************
MODIFICA AI CAMPI DELLE TABELLA  U_MAG_GG
**************************************************************
*/

ALTER TABLE [dbo].[U_MAG_GG] ALTER COLUMN
 	 [MAG_DESART] varchar (100) NULL
go


/* 
**************************************************************
MODIFICA AI CAMPI DELLE TABELLA  U_MAG_MO
**************************************************************
*/

ALTER TABLE [dbo].[U_MAG_MO] ALTER COLUMN
 	 [MOV_DESART] varchar (100) NULL
go



/* 
**************************************************************
MODIFICA AI CAMPI DELLE TABELLA  L_MAG_GG
**************************************************************
*/

ALTER TABLE [dbo].[L_MAG_GG] ALTER COLUMN
 	 [MAG_DESART] varchar (100) NULL
go



/* 
**************************************************************
MODIFICA AI CAMPI DELLE TABELLA  LOG_NEW_MAG
**************************************************************
*/

ALTER TABLE [dbo].[LOG_NEW_MAG] ALTER COLUMN
 	 [MAG_DESART] varchar (100) NULL
go




/* 
**************************************************************
MODIFICA AI CAMPI DELLE TABELLA  U_PRD_D2
**************************************************************
*/

ALTER TABLE [dbo].[U_PRD_D2] ALTER COLUMN
 	 [PR2_DESART] varchar (100) NULL
go




/* 
**************************************************************
MODIFICA AI CAMPI DELLE TABELLA  U_PRD_D3
**************************************************************
*/

ALTER TABLE [dbo].[U_PRD_D3] ALTER COLUMN
 	 [PR3_DESBOB] varchar (100) NULL
go
ALTER TABLE [dbo].[U_PRD_D3] ALTER COLUMN
 	 [PR3_DESADE] varchar (100) NULL
go




/* 
**************************************************************
MODIFICA AI CAMPI DELLE TABELLA  U_PRD_D4
**************************************************************
*/

ALTER TABLE [dbo].[U_PRD_D4] ALTER COLUMN
 	 [PR4_DESART] varchar (100) NULL
go




/* 
**************************************************************
MODIFICA AI CAMPI DELLE TABELLA  U_PRD_DR
**************************************************************
*/

ALTER TABLE [dbo].[U_PRD_DR] ALTER COLUMN
 	 [PRR_DESART] varchar (100) NULL
go



/* 
**************************************************************
MODIFICA AI CAMPI DELLE TABELLA  U_PRD_D5
**************************************************************
*/

ALTER TABLE [dbo].[U_PRD_D5] ALTER COLUMN
 	 [PR5_DESART] varchar (100) NULL
go



/* 
**************************************************************
MODIFICA AI CAMPI DELLE TABELLA  U_PRD_PK
**************************************************************
*/

ALTER TABLE [dbo].[U_PRD_PK] ALTER COLUMN
 	 [PR5_DESART] varchar (100) NULL
go