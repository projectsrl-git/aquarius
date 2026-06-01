 
/* 

**************************************************************

COME CANCELLARE UN CAMPO IN UNA TABELLA

**************************************************************

*/

ALTER TABLE [dbo].[INVENTORY] DROP CONSTRAINT

      DF_INVENTORY_CODFOR

GO

 

ALTER TABLE [dbo].[INVENTORY] DROP COLUMN 

       CODFOR

GO

