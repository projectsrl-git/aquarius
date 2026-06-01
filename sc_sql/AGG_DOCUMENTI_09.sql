
/* 
********************************************************************************
ALLARGAMENTO CAMPI RELATIVI ALLA CONSEGNA SU TUTTI I DOCUMENTI
********************************************************************************
*/

/* --------------------- CLIENTI-------------------------- 
*/
ALTER TABLE [dbo].[U_CLI_AN] ALTER COLUMN 
	CLI_RAGSOC varchar(150) COLLATE Latin1_General_CI_AS NULL
go

ALTER TABLE [dbo].[U_CLI_AN] ALTER COLUMN 
	CLI_INDIR varchar(150) COLLATE Latin1_General_CI_AS NULL
go

ALTER TABLE [dbo].[U_CLI_AN] ALTER COLUMN 
	CLI_CAP varchar(15) COLLATE Latin1_General_CI_AS NULL
go

ALTER TABLE [dbo].[U_CLI_AN] ALTER COLUMN 
	CLI_LOCALI varchar(150) COLLATE Latin1_General_CI_AS NULL
go

/* --------------------- FATTURE-------------------------- 
*/
ALTER TABLE [dbo].[U_FAT_TT] ALTER COLUMN 
	ORD_RAGC varchar(150) COLLATE Latin1_General_CI_AS NULL
go

ALTER TABLE [dbo].[U_FAT_TT] ALTER COLUMN 
	ORD_INDC varchar(150) COLLATE Latin1_General_CI_AS NULL
go

ALTER TABLE [dbo].[U_FAT_TT] ALTER COLUMN 
	ORD_CAPC varchar(15) COLLATE Latin1_General_CI_AS NULL
go

ALTER TABLE [dbo].[U_FAT_TT] ALTER COLUMN 
	ORD_LOCC varchar(150) COLLATE Latin1_General_CI_AS NULL
go

ALTER TABLE [dbo].[U_FAT_TT] ALTER COLUMN 
	ORD_RAGSOC varchar(150) COLLATE Latin1_General_CI_AS NULL
go

ALTER TABLE [dbo].[U_FAT_TT] ALTER COLUMN 
	ORD_INDIRI varchar(150) COLLATE Latin1_General_CI_AS NULL
go

ALTER TABLE [dbo].[U_FAT_TT] ALTER COLUMN 
	ORD_CAP varchar(15) COLLATE Latin1_General_CI_AS NULL
go

ALTER TABLE [dbo].[U_FAT_TT] ALTER COLUMN 
	ORD_LOCALI varchar(150) COLLATE Latin1_General_CI_AS NULL
go


/* ------------------ FATTURE PROFORMA ------------------- 
*/
ALTER TABLE [dbo].[U_FAP_TT] ALTER COLUMN 
	ORD_RAGC varchar(150) COLLATE Latin1_General_CI_AS NULL
go

ALTER TABLE [dbo].[U_FAP_TT] ALTER COLUMN 
	ORD_INDC varchar(150) COLLATE Latin1_General_CI_AS NULL
go

ALTER TABLE [dbo].[U_FAP_TT] ALTER COLUMN 
	ORD_CAPC varchar(15) COLLATE Latin1_General_CI_AS NULL
go

ALTER TABLE [dbo].[U_FAP_TT] ALTER COLUMN 
	ORD_LOCC varchar(150) COLLATE Latin1_General_CI_AS NULL
go

ALTER TABLE [dbo].[U_FAP_TT] ALTER COLUMN 
	ORD_RAGSOC varchar(150) COLLATE Latin1_General_CI_AS NULL
go

ALTER TABLE [dbo].[U_FAP_TT] ALTER COLUMN 
	ORD_INDIRI varchar(150) COLLATE Latin1_General_CI_AS NULL
go

ALTER TABLE [dbo].[U_FAP_TT] ALTER COLUMN 
	ORD_CAP varchar(15) COLLATE Latin1_General_CI_AS NULL
go

ALTER TABLE [dbo].[U_FAP_TT] ALTER COLUMN 
	ORD_LOCALI varchar(150) COLLATE Latin1_General_CI_AS NULL
go

/* ------------------ ORDINI CLIENTI ------------------- 
*/
ALTER TABLE [dbo].[U_ORD_TT] ALTER COLUMN 
	ORD_RAGC varchar(150) COLLATE Latin1_General_CI_AS NULL
go

ALTER TABLE [dbo].[U_ORD_TT] ALTER COLUMN 
	ORD_INDC varchar(150) COLLATE Latin1_General_CI_AS NULL
go

ALTER TABLE [dbo].[U_ORD_TT] ALTER COLUMN 
	ORD_CAPC varchar(15) COLLATE Latin1_General_CI_AS NULL
go

ALTER TABLE [dbo].[U_ORD_TT] ALTER COLUMN 
	ORD_LOCC varchar(150) COLLATE Latin1_General_CI_AS NULL
go

ALTER TABLE [dbo].[U_ORD_TT] ALTER COLUMN 
	ORD_RAGSOC varchar(150) COLLATE Latin1_General_CI_AS NULL
go

ALTER TABLE [dbo].[U_ORD_TT] ALTER COLUMN 
	ORD_INDIRI varchar(150) COLLATE Latin1_General_CI_AS NULL
go

ALTER TABLE [dbo].[U_ORD_TT] ALTER COLUMN 
	ORD_CAP varchar(15) COLLATE Latin1_General_CI_AS NULL
go

ALTER TABLE [dbo].[U_ORD_TT] ALTER COLUMN 
	ORD_LOCALI varchar(150) COLLATE Latin1_General_CI_AS NULL
go

/* ------------------ PREVENTIVI CLIENTI ------------------- 
*/
ALTER TABLE [dbo].[U_OFF_TT] ALTER COLUMN 
	ORD_RAGC varchar(150) COLLATE Latin1_General_CI_AS NULL
go

ALTER TABLE [dbo].[U_OFF_TT] ALTER COLUMN 
	ORD_INDC varchar(150) COLLATE Latin1_General_CI_AS NULL
go

ALTER TABLE [dbo].[U_OFF_TT] ALTER COLUMN 
	ORD_CAPC varchar(15) COLLATE Latin1_General_CI_AS NULL
go

ALTER TABLE [dbo].[U_OFF_TT] ALTER COLUMN 
	ORD_LOCC varchar(150) COLLATE Latin1_General_CI_AS NULL
go

ALTER TABLE [dbo].[U_OFF_TT] ALTER COLUMN 
	ORD_RAGSOC varchar(150) COLLATE Latin1_General_CI_AS NULL
go

ALTER TABLE [dbo].[U_OFF_TT] ALTER COLUMN 
	ORD_INDIRI varchar(150) COLLATE Latin1_General_CI_AS NULL
go

ALTER TABLE [dbo].[U_OFF_TT] ALTER COLUMN 
	ORD_CAP varchar(15) COLLATE Latin1_General_CI_AS NULL
go

ALTER TABLE [dbo].[U_OFF_TT] ALTER COLUMN 
	ORD_LOCALI varchar(150) COLLATE Latin1_General_CI_AS NULL
go


/* -------------------- DDT CLIENTI --------------------- 
*/
ALTER TABLE [dbo].[U_BOL_TT] ALTER COLUMN 
	ORD_RAGC varchar(150) COLLATE Latin1_General_CI_AS NULL
go

ALTER TABLE [dbo].[U_BOL_TT] ALTER COLUMN 
	ORD_INDC varchar(150) COLLATE Latin1_General_CI_AS NULL
go

ALTER TABLE [dbo].[U_BOL_TT] ALTER COLUMN 
	ORD_CAPC varchar(15) COLLATE Latin1_General_CI_AS NULL
go

ALTER TABLE [dbo].[U_BOL_TT] ALTER COLUMN 
	ORD_LOCC varchar(150) COLLATE Latin1_General_CI_AS NULL
go

ALTER TABLE [dbo].[U_BOL_TT] ALTER COLUMN 
	ORD_RAGSOC varchar(150) COLLATE Latin1_General_CI_AS NULL
go

ALTER TABLE [dbo].[U_BOL_TT] ALTER COLUMN 
	ORD_INDIRI varchar(150) COLLATE Latin1_General_CI_AS NULL
go

ALTER TABLE [dbo].[U_BOL_TT] ALTER COLUMN 
	ORD_CAP varchar(15) COLLATE Latin1_General_CI_AS NULL
go

ALTER TABLE [dbo].[U_BOL_TT] ALTER COLUMN 
	ORD_LOCALI varchar(150) COLLATE Latin1_General_CI_AS NULL
go

/* -------------------- DDT CLIENTI LEGAMI----------------- 
*/
ALTER TABLE [dbo].[L_BOL_TT] ALTER COLUMN 
	ORD_RAGC varchar(150) COLLATE Latin1_General_CI_AS NULL
go

ALTER TABLE [dbo].[L_BOL_TT] ALTER COLUMN 
	ORD_INDC varchar(150) COLLATE Latin1_General_CI_AS NULL
go

ALTER TABLE [dbo].[L_BOL_TT] ALTER COLUMN 
	ORD_CAPC varchar(15) COLLATE Latin1_General_CI_AS NULL
go

ALTER TABLE [dbo].[L_BOL_TT] ALTER COLUMN 
	ORD_LOCC varchar(150) COLLATE Latin1_General_CI_AS NULL
go

ALTER TABLE [dbo].[L_BOL_TT] ALTER COLUMN 
	ORD_RAGSOC varchar(150) COLLATE Latin1_General_CI_AS NULL
go

ALTER TABLE [dbo].[L_BOL_TT] ALTER COLUMN 
	ORD_INDIRI varchar(150) COLLATE Latin1_General_CI_AS NULL
go

ALTER TABLE [dbo].[L_BOL_TT] ALTER COLUMN 
	ORD_CAP varchar(15) COLLATE Latin1_General_CI_AS NULL
go

ALTER TABLE [dbo].[L_BOL_TT] ALTER COLUMN 
	ORD_LOCALI varchar(150) COLLATE Latin1_General_CI_AS NULL
go

