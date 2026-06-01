

/* 

**************************************************************

COME CANCELLARE UN CAMPO IN UNA TABELLA

**************************************************************

*/
ALTER TABLE [dbo].[U_OFF_DD] DROP CONSTRAINT

      DF_U_OFF_DD_ORD_CODSYS

GO

ALTER TABLE [dbo].[U_OFF_DD] DROP COLUMN 

       ORD_CODSYS

GO



/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_OFF_DD] ADD 
		ORD_CODSYS varchar (10) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[U_OFF_DD] WITH NOCHECK ADD 
        CONSTRAINT [DF_U_OFF_DD_ORD_CODSYS] DEFAULT ('') FOR [ORD_CODSYS]
go


UPDATE U_OFF_DD SET ORD_CODSYS	= SUBSTRING(CAST(id_unique AS VARCHAR(100)),27,10)
