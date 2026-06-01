 

/* 

**************************************************************

COME CANCELLARE UN CAMPO IN UNA TABELLA

**************************************************************

*/
ALTER TABLE [dbo].[U_ORD_TT] DROP CONSTRAINT

      DF_U_ORD_TT_ORD_QTAMC

GO

ALTER TABLE [dbo].[U_ORD_TT] DROP COLUMN 

       ORD_QTAMC

GO

 

 

/* 

**************************************************************

COME CANCELLARE UN CAMPO IN UNA TABELLA

**************************************************************

*/

ALTER TABLE [dbo].[U_ORD_TT] DROP CONSTRAINT

      DF_U_ORD_TT_ORD_QTAMC1

GO

ALTER TABLE [dbo].[U_ORD_TT] DROP COLUMN 

       ORD_QTAMC1

GO

 

 

 

