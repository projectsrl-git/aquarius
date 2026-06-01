
/* 
*************************************************************************************
ELIMINAZIONE CAMPI 'SCONTI MINIMI' IN TABELLA SCONTI PER CLIENTE/CAT.MERCEOLOGICA
*************************************************************************************
*/

ALTER TABLE [dbo].[U_SCO_CM] DROP CONSTRAINT
      DF_U_SCO_CM_SCO_SCMIN1
GO
ALTER TABLE [dbo].[U_SCO_CM] DROP COLUMN 
       SCO_SCMIN1
GO

ALTER TABLE [dbo].[U_SCO_CM] DROP CONSTRAINT
      DF_U_SCO_CM_SCO_SCMIN2
GO
ALTER TABLE [dbo].[U_SCO_CM] DROP COLUMN 
       SCO_SCMIN2
GO
