 

/* 

**************************************************************

COME CANCELLARE UN CAMPO IN UNA TABELLA

**************************************************************

*/
ALTER TABLE [dbo].[U_AZI_PA] DROP CONSTRAINT

      DF_U_AZI_PA_azi_noskprod

GO

ALTER TABLE [dbo].[U_AZI_PA] DROP COLUMN 

       azi_noskprod

GO

 
 
/* 

**************************************************************

COME CANCELLARE UN CAMPO IN UNA TABELLA

**************************************************************

*/
ALTER TABLE [dbo].[U_AZI_PA] DROP CONSTRAINT

      DF_U_AZI_PA_azi_noconti

GO

ALTER TABLE [dbo].[U_AZI_PA] DROP COLUMN 

       azi_noconti

GO

  
/* 

**************************************************************

COME CANCELLARE UN CAMPO IN UNA TABELLA

**************************************************************

*/
ALTER TABLE [dbo].[U_AZI_PA] DROP CONSTRAINT

      DF_U_AZI_PA_azi_nocampicli

GO

ALTER TABLE [dbo].[U_AZI_PA] DROP COLUMN 

       azi_nocampicli

GO

 