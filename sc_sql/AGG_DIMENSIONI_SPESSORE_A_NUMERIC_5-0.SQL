
/* 
*****************************************************************************
MODIFICA DIMENSIONE DELLO SPESSORE PER I CAMPI 'SPESSORE' DI TUTTE LE TABELLE
N.B.: PER ALCUNE TABELLE E' STATO NECESSARIO ELIMINARE
GLI INDICI IN CUI E' COINVOLTO IL CAMPO 'SPESSORE'
*****************************************************************************
*/

if exists (select * from sys.indexes where name = 'INDICE_13' and object_id = object_id(N'[dbo].[U_ART_PR]'))
	DROP INDEX INDICE_13 ON U_ART_PR
GO
if exists (select * from sys.indexes where name = 'U_ART_01' and object_id = object_id(N'[dbo].[U_ART_PR]'))
	DROP INDEX U_ART_01 ON U_ART_PR
GO
if exists (select * from sys.indexes where name = 'U_ART_23' and object_id = object_id(N'[dbo].[U_ART_PR]'))
	DROP INDEX U_ART_23 ON U_ART_PR
GO
if exists (select * from sys.indexes where name = 'U_ART_28' and object_id = object_id(N'[dbo].[U_ART_PR]'))
	DROP INDEX U_ART_28 ON U_ART_PR
GO
ALTER TABLE [dbo].[U_ART_PR] ALTER COLUMN
	 [ART_SPESSO] NUMERIC(5,0) NULL
GO


ALTER TABLE [dbo].[U_BFO_DD] ALTER COLUMN
	 [ORD_SPESSO] NUMERIC(5,0) NULL
GO


ALTER TABLE [dbo].[U_BOL_DD] ALTER COLUMN
	 [ORD_SPESSO] NUMERIC(5,0) NULL
GO


ALTER TABLE [dbo].[U_CER_CO] ALTER COLUMN
	 [CER_SPESSO] NUMERIC(5,0) NULL
GO


ALTER TABLE [dbo].[U_FAB_CL] ALTER COLUMN
	 [FAB_SPESSO] NUMERIC(5,0) NULL
GO


ALTER TABLE [dbo].[U_FAP_DD] ALTER COLUMN
	 [ORD_SPESSO] NUMERIC(5,0) NULL
GO


if exists (select * from sys.indexes where name = 'INDICE_03' and object_id = object_id(N'[dbo].[U_FAT_DD]'))
	DROP INDEX INDICE_03 ON U_FAT_DD
GO
if exists (select * from sys.indexes where name = 'INDICE_04' and object_id = object_id(N'[dbo].[U_FAT_DD]'))
	DROP INDEX INDICE_04 ON U_FAT_DD
GO
ALTER TABLE [dbo].[U_FAT_DD] ALTER COLUMN
	 [ORD_SPESSO] NUMERIC(5,0) NULL
GO


ALTER TABLE [dbo].[U_MAG_CP] ALTER COLUMN
	 [MAG_SPESSO] NUMERIC(5,0) NULL
GO


if exists (select * from sys.indexes where name = 'INDICE_01' and object_id = object_id(N'[dbo].[U_MAN_CO]'))
	DROP INDEX INDICE_01 ON U_MAN_CO
GO
if exists (select * from sys.indexes where name = 'INDICE_07' and object_id = object_id(N'[dbo].[U_MAN_CO]'))
	DROP INDEX INDICE_07 ON U_MAN_CO
GO
if exists (select * from sys.indexes where name = 'INDICE_09' and object_id = object_id(N'[dbo].[U_MAN_CO]'))
	DROP INDEX INDICE_09 ON U_MAN_CO
GO
ALTER TABLE [dbo].[U_MAN_CO] ALTER COLUMN
	 [MAN_SPESAL] NUMERIC(5,0) NULL
GO


ALTER TABLE [dbo].[U_MPF_CQ] ALTER COLUMN
	 [MPF_SPESSO] NUMERIC(5,0) NULL
GO
ALTER TABLE [dbo].[U_MPF_CQ] ALTER COLUMN
	 [MPF_SPES_V] NUMERIC(5,0) NULL
GO


ALTER TABLE [dbo].[U_OFF_DD] ALTER COLUMN
	 [ORD_SPESSO] NUMERIC(5,0) NULL
GO


if exists (select * from sys.indexes where name = 'INDICE_01' and object_id = object_id(N'[dbo].[U_ORD_DD]'))
	DROP INDEX INDICE_01 ON U_ORD_DD
GO
ALTER TABLE [dbo].[U_ORD_DD] ALTER COLUMN
	 [ORD_SPESSO] NUMERIC(5,0) NULL
GO


if exists (select * from sys.indexes where name = 'INDICE_01' and object_id = object_id(N'[dbo].[U_ORF_DD]'))
	DROP INDEX INDICE_01 ON U_ORF_DD
GO
ALTER TABLE [dbo].[U_ORF_DD] ALTER COLUMN
	 [ORD_SPESSO] NUMERIC(5,0) NULL
GO


if exists (select * from sys.indexes where name = 'U_ORF_03' and object_id = object_id(N'[dbo].[U_ORF_DL]'))
	DROP INDEX U_ORF_03 ON U_ORF_DL
GO
ALTER TABLE [dbo].[U_ORF_DL] ALTER COLUMN
	 [ORD_SPESSO] NUMERIC(5,0) NULL
GO


ALTER TABLE [dbo].[U_ORF_EV] ALTER COLUMN
	 [ORD_SPESSO] NUMERIC(5,0) NULL
GO


if exists (select * from sys.indexes where name = 'INDICE_02' and object_id = object_id(N'[dbo].[U_PAR_MY]'))
	DROP INDEX INDICE_02 ON U_PAR_MY
GO
ALTER TABLE [dbo].[U_PAR_MY] ALTER COLUMN
	 [PAR_CODSPE] NUMERIC(5,0) NULL
GO


ALTER TABLE [dbo].[U_PCK_DD] ALTER COLUMN
	 [ORD_SPESSO] NUMERIC(5,0) NULL
GO


ALTER TABLE [dbo].[U_PED_DT] ALTER COLUMN
	 [MAG_SPESSO] NUMERIC(5,0) NULL
GO


ALTER TABLE [dbo].[U_PED_PL] ALTER COLUMN
	 [MAG_SPESSO] NUMERIC(5,0) NULL
GO


ALTER TABLE [dbo].[U_PRD_CD] ALTER COLUMN
	 [PDD_SPESSO] NUMERIC(5,0) NULL
GO


ALTER TABLE [dbo].[U_PRD_D2] ALTER COLUMN
	 [PR2_SPEBOB] NUMERIC(5,0) NULL
GO


ALTER TABLE [dbo].[U_PRD_D3] ALTER COLUMN
	 [PR3_SPESSO] NUMERIC(5,0) NULL
GO
ALTER TABLE [dbo].[U_PRD_D3] ALTER COLUMN
	 [PR3_SPECAR] NUMERIC(5,0) NULL
GO


ALTER TABLE [dbo].[U_PRD_D4] ALTER COLUMN
	 [PR4_SPESSO] NUMERIC(5,0) NULL
GO
ALTER TABLE [dbo].[U_PRD_D4] ALTER COLUMN
	 [PR4_SPECAR] NUMERIC(5,0) NULL
GO


ALTER TABLE [dbo].[U_PRD_D5] ALTER COLUMN
	 [PR5_SPESSO] NUMERIC(5,0) NULL
GO
ALTER TABLE [dbo].[U_PRD_D5] ALTER COLUMN
	 [PR5_SPETAG] NUMERIC(5,0) NULL
GO


ALTER TABLE [dbo].[U_PRD_DR] ALTER COLUMN
	 [PRR_SPESSO] NUMERIC(5,0) NULL
GO
ALTER TABLE [dbo].[U_PRD_DR] ALTER COLUMN
	 [PRR_SPECAR] NUMERIC(5,0) NULL
GO


ALTER TABLE [dbo].[U_PRD_DS] ALTER COLUMN
	 [PRS_SPESSO] NUMERIC(5,0) NULL
GO
ALTER TABLE [dbo].[U_PRD_DS] ALTER COLUMN
	 [PRS_SPECAR] NUMERIC(5,0) NULL
GO


ALTER TABLE [dbo].[U_PRD_PK] ALTER COLUMN
	 [PR5_SPESSO] NUMERIC(5,0) NULL
GO
ALTER TABLE [dbo].[U_PRD_PK] ALTER COLUMN
	 [PR5_SPETAG] NUMERIC(5,0) NULL
GO


ALTER TABLE [dbo].[U_PRG_DO] ALTER COLUMN
	 [MAG_SPESSO] NUMERIC(5,0) NULL
GO


if exists (select * from sys.indexes where name = 'U_PRO_01' and object_id = object_id(N'[dbo].[U_PRO_MY]'))
	DROP INDEX U_PRO_01 ON U_PRO_MY
GO
ALTER TABLE [dbo].[U_PRO_MY] ALTER COLUMN
	 [MIC_SPESSO] NUMERIC(5,0) NULL
GO
ALTER TABLE [dbo].[U_PRO_MY] ALTER COLUMN
	 [MIC_SPESDA] NUMERIC(5,0) NULL
GO
ALTER TABLE [dbo].[U_PRO_MY] ALTER COLUMN
	 [MIC_SPESAL] NUMERIC(5,0) NULL
GO
ALTER TABLE [dbo].[U_PRO_MY] ALTER COLUMN
	 [MIC_SPEORD] NUMERIC(5,0) NULL
GO


ALTER TABLE [dbo].[U_RAP_SP] ALTER COLUMN
	 [RAP_VELSPA] NUMERIC(5,0) NULL
GO


ALTER TABLE [dbo].[U_SLC_CQ] ALTER COLUMN
	 [SLC_SPESSO] NUMERIC(5,0) NULL
GO


ALTER TABLE [dbo].[U_SLF_CQ] ALTER COLUMN
	 [SLF_FSSPES] NUMERIC(5,0) NULL
GO


ALTER TABLE [dbo].[U_SLF_CQ] ALTER COLUMN
	 [SLF_FSSP_V] NUMERIC(5,0) NULL
GO


ALTER TABLE [dbo].[U_STC_AN] ALTER COLUMN
	 [ORD_SPESSO] NUMERIC(5,0) NULL
GO
















