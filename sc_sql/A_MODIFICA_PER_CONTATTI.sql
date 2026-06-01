/* 
**************************************************************
COME MODIFICARE UN CAMPO ESISTENTE IN UNA TABELLA
**************************************************************

ATTENZIONE!!!!!
SE LA VARIAZIONE COMPORTA UNA RIDUZIONE DELLE DIMENSIONI DEL CAMPO,
SQL LO PERMETTE SOLO SE LA DIMENSIONE DEL DATO CONTENUTO E' 
UGUALE O INFERIORE ALLA NUOVA DIMENSIONE (SU TUTTI I RECORD
PRESENTI IN TABELLA)
**************************************************************
*/
ALTER TABLE [dbo].[U_CLI_AN] ALTER COLUMN
	 CLI_RAGSOC varchar(70) COLLATE Latin1_General_CI_AS NULL
GO
ALTER TABLE [dbo].[U_CLI_AN] ALTER COLUMN
	 CLI_INDIR varchar(70) COLLATE Latin1_General_CI_AS NULL
GO
ALTER TABLE [dbo].[U_CLI_AN] ALTER COLUMN
	 CLI_LOCALI varchar(70) COLLATE Latin1_General_CI_AS NULL 
GO

--**************************************************************

ALTER TABLE [dbo].[U_CLI_FI] ALTER COLUMN
	 FID_RAGSOC varchar(70) COLLATE Latin1_General_CI_AS NULL
GO

--**************************************************************

ALTER TABLE [dbo].[U_FOR_AN] ALTER COLUMN
	 FOR_RAGSOC varchar(70) COLLATE Latin1_General_CI_AS NULL 
GO
ALTER TABLE [dbo].[U_FOR_AN] ALTER COLUMN
	 FOR_INDIR varchar(70) COLLATE Latin1_General_CI_AS NULL 
GO
ALTER TABLE [dbo].[U_FOR_AN] ALTER COLUMN
	 FOR_LOCALI varchar(70) COLLATE Latin1_General_CI_AS NULL 
GO

--**************************************************************

ALTER TABLE [dbo].[U_FOR_PR] ALTER COLUMN
	 FPR_RAGFOR varchar(70) COLLATE Latin1_General_CI_AS NULL 
GO

--**************************************************************

ALTER TABLE [dbo].[U_FOR_PR] ALTER COLUMN
	 FPR_RAGFOR varchar(70) COLLATE Latin1_General_CI_AS NULL 
GO

--**************************************************************

ALTER TABLE [dbo].[U_ORD_TT] ALTER COLUMN
	 ORD_RAGSOC varchar(70) COLLATE Latin1_General_CI_AS NULL 
GO
ALTER TABLE [dbo].[U_ORD_TT] ALTER COLUMN
	 ORD_INDIRI varchar(70) COLLATE Latin1_General_CI_AS NULL 
GO
ALTER TABLE [dbo].[U_ORD_TT] ALTER COLUMN
	 ORD_LOCALI varchar(70) COLLATE Latin1_General_CI_AS NULL 
GO
ALTER TABLE [dbo].[U_ORD_TT] ALTER COLUMN
	 ORD_RAGC varchar(70) COLLATE Latin1_General_CI_AS NULL 
GO
ALTER TABLE [dbo].[U_ORD_TT] ALTER COLUMN
	 ORD_INDC varchar(70) COLLATE Latin1_General_CI_AS NULL 
GO
ALTER TABLE [dbo].[U_ORD_TT] ALTER COLUMN
	 ORD_LOCC varchar(70) COLLATE Latin1_General_CI_AS NULL
GO

--**************************************************************

ALTER TABLE [dbo].[U_ORD_DD] ALTER COLUMN
	 ORS_RAGSOC varchar(70) COLLATE Latin1_General_CI_AS NULL 
GO

ALTER TABLE [dbo].[U_ORD_DD] ALTER COLUMN
	 ORS_DESTIN varchar(70) COLLATE Latin1_General_CI_AS NULL 
GO

--**************************************************************

ALTER TABLE [dbo].[U_ORF_TT] ALTER COLUMN
	 ORD_RAGSOC varchar(70) COLLATE Latin1_General_CI_AS NULL 
GO
ALTER TABLE [dbo].[U_ORF_TT] ALTER COLUMN
	 ORD_INDIRI varchar(70) COLLATE Latin1_General_CI_AS NULL 
GO
ALTER TABLE [dbo].[U_ORF_TT] ALTER COLUMN
	 ORD_LOCALI varchar(70) COLLATE Latin1_General_CI_AS NULL 
GO
ALTER TABLE [dbo].[U_ORF_TT] ALTER COLUMN
	 ORD_RAGC varchar(70) COLLATE Latin1_General_CI_AS NULL 
GO
ALTER TABLE [dbo].[U_ORF_TT] ALTER COLUMN
	 ORD_INDC varchar(70) COLLATE Latin1_General_CI_AS NULL 
GO
ALTER TABLE [dbo].[U_ORF_TT] ALTER COLUMN
	 ORD_LOCC varchar(70) COLLATE Latin1_General_CI_AS NULL
GO

--**************************************************************

ALTER TABLE [dbo].[U_ORF_DD] ALTER COLUMN
	 ORS_RAGSOC varchar(70) COLLATE Latin1_General_CI_AS NULL 
GO

ALTER TABLE [dbo].[U_ORF_DD] ALTER COLUMN
	 ORS_DESTIN varchar(70) COLLATE Latin1_General_CI_AS NULL 
GO

--**************************************************************

ALTER TABLE [dbo].[U_BOL_TT] ALTER COLUMN
	 ORD_RAGSOC varchar(70) COLLATE Latin1_General_CI_AS NULL 
GO
ALTER TABLE [dbo].[U_BOL_TT] ALTER COLUMN
	 ORD_INDIRI varchar(70) COLLATE Latin1_General_CI_AS NULL 
GO
ALTER TABLE [dbo].[U_BOL_TT] ALTER COLUMN
	 ORD_LOCALI varchar(70) COLLATE Latin1_General_CI_AS NULL 
GO
ALTER TABLE [dbo].[U_BOL_TT] ALTER COLUMN
	 ORD_RAGC varchar(70) COLLATE Latin1_General_CI_AS NULL 
GO
ALTER TABLE [dbo].[U_BOL_TT] ALTER COLUMN
	 ORD_INDC varchar(70) COLLATE Latin1_General_CI_AS NULL 
GO
ALTER TABLE [dbo].[U_BOL_TT] ALTER COLUMN
	 ORD_LOCC varchar(70) COLLATE Latin1_General_CI_AS NULL
GO

--**************************************************************

ALTER TABLE [dbo].[U_BOL_DD] ALTER COLUMN
	 ORS_RAGSOC varchar(70) COLLATE Latin1_General_CI_AS NULL 
GO

ALTER TABLE [dbo].[U_BOL_DD] ALTER COLUMN
	 ORS_DESTIN varchar(70) COLLATE Latin1_General_CI_AS NULL 
GO

--**************************************************************

ALTER TABLE [dbo].[U_BOF_TT] ALTER COLUMN
	 ORD_RAGSOC varchar(70) COLLATE Latin1_General_CI_AS NULL 
GO
ALTER TABLE [dbo].[U_BOF_TT] ALTER COLUMN
	 ORD_INDIRI varchar(70) COLLATE Latin1_General_CI_AS NULL 
GO
ALTER TABLE [dbo].[U_BOF_TT] ALTER COLUMN
	 ORD_LOCALI varchar(70) COLLATE Latin1_General_CI_AS NULL 
GO
ALTER TABLE [dbo].[U_BOF_TT] ALTER COLUMN
	 ORD_RAGC varchar(70) COLLATE Latin1_General_CI_AS NULL 
GO
ALTER TABLE [dbo].[U_BOF_TT] ALTER COLUMN
	 ORD_INDC varchar(70) COLLATE Latin1_General_CI_AS NULL 
GO
ALTER TABLE [dbo].[U_BOF_TT] ALTER COLUMN
	 ORD_LOCC varchar(70) COLLATE Latin1_General_CI_AS NULL
GO

--**************************************************************

ALTER TABLE [dbo].[U_BOF_DD] ALTER COLUMN
	 ORS_RAGSOC varchar(70) COLLATE Latin1_General_CI_AS NULL 
GO

ALTER TABLE [dbo].[U_BOF_DD] ALTER COLUMN
	 ORS_DESTIN varchar(70) COLLATE Latin1_General_CI_AS NULL 
GO

--**************************************************************

ALTER TABLE [dbo].[U_BFO_TT] ALTER COLUMN
	 ORD_RAGSOC varchar(70) COLLATE Latin1_General_CI_AS NULL 
GO
ALTER TABLE [dbo].[U_BFO_TT] ALTER COLUMN
	 ORD_INDIRI varchar(70) COLLATE Latin1_General_CI_AS NULL 
GO
ALTER TABLE [dbo].[U_BFO_TT] ALTER COLUMN
	 ORD_LOCALI varchar(70) COLLATE Latin1_General_CI_AS NULL 
GO
ALTER TABLE [dbo].[U_BFO_TT] ALTER COLUMN
	 ORD_RAGC varchar(70) COLLATE Latin1_General_CI_AS NULL 
GO
ALTER TABLE [dbo].[U_BFO_TT] ALTER COLUMN
	 ORD_INDC varchar(70) COLLATE Latin1_General_CI_AS NULL 
GO
ALTER TABLE [dbo].[U_BFO_TT] ALTER COLUMN
	 ORD_LOCC varchar(70) COLLATE Latin1_General_CI_AS NULL
GO

--**************************************************************

ALTER TABLE [dbo].[U_BFO_DD] ALTER COLUMN
	 ORS_RAGSOC varchar(70) COLLATE Latin1_General_CI_AS NULL 
GO

ALTER TABLE [dbo].[U_BFO_DD] ALTER COLUMN
	 ORS_DESTIN varchar(70) COLLATE Latin1_General_CI_AS NULL 
GO

--**************************************************************

ALTER TABLE [dbo].[U_FAP_TT] ALTER COLUMN
	 ORD_RAGSOC varchar(70) COLLATE Latin1_General_CI_AS NULL 
GO
ALTER TABLE [dbo].[U_FAP_TT] ALTER COLUMN
	 ORD_INDIRI varchar(70) COLLATE Latin1_General_CI_AS NULL 
GO
ALTER TABLE [dbo].[U_FAP_TT] ALTER COLUMN
	 ORD_LOCALI varchar(70) COLLATE Latin1_General_CI_AS NULL 
GO

--**************************************************************

ALTER TABLE [dbo].[U_FAP_DD] ALTER COLUMN
	 ORS_RAGSOC varchar(70) COLLATE Latin1_General_CI_AS NULL 
GO

ALTER TABLE [dbo].[U_FAP_DD] ALTER COLUMN
	 ORS_DESTIN varchar(70) COLLATE Latin1_General_CI_AS NULL 
GO

--**************************************************************

ALTER TABLE [dbo].[U_FAT_TT] ALTER COLUMN
	 ORD_RAGSOC varchar(70) COLLATE Latin1_General_CI_AS NULL 
GO
ALTER TABLE [dbo].[U_FAT_TT] ALTER COLUMN
	 ORD_INDIRI varchar(70) COLLATE Latin1_General_CI_AS NULL 
GO
ALTER TABLE [dbo].[U_FAT_TT] ALTER COLUMN
	 ORD_LOCALI varchar(70) COLLATE Latin1_General_CI_AS NULL 
GO

--**************************************************************

ALTER TABLE [dbo].[U_FAT_DD] ALTER COLUMN
	 ORS_RAGSOC varchar(70) COLLATE Latin1_General_CI_AS NULL 
GO

ALTER TABLE [dbo].[U_FAT_DD] ALTER COLUMN
	 ORS_DESTIN varchar(70) COLLATE Latin1_General_CI_AS NULL 
GO

--**************************************************************

ALTER TABLE [dbo].[U_CNT_TT] ALTER COLUMN
	 CNT_RAGSOC varchar(70) COLLATE Latin1_General_CI_AS NULL 
GO
ALTER TABLE [dbo].[U_CNT_TT] ALTER COLUMN
	 CNT_INDIRI varchar(70) COLLATE Latin1_General_CI_AS NULL 
GO
ALTER TABLE [dbo].[U_CNT_TT] ALTER COLUMN
	 CNT_LOCALI varchar(70) COLLATE Latin1_General_CI_AS NULL 
GO

--**************************************************************

ALTER TABLE [dbo].[U_CNT_DD] ALTER COLUMN
	 COS_RAGSOC varchar(70) COLLATE Latin1_General_CI_AS NULL 
GO

--**************************************************************

ALTER TABLE [dbo].[U_CMP_CL] ALTER COLUMN
	 CMP_RAGSOC varchar(70) COLLATE Latin1_General_CI_AS NULL 
GO