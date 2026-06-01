
/* 
*************************************************************************************
ELIMINAZIONE CAMPO IN TABELLA
*************************************************************************************
*/

ALTER TABLE [dbo].[U_ART_AN] DROP CONSTRAINT
      DF_U_ART_AN_ART_GRUPRO
GO
ALTER TABLE [dbo].[U_ART_AN] DROP COLUMN 
       ART_GRUPRO
GO