
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[PARA] ADD 
	 SOLOIMPIVA varchar(3) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[PARA] WITH NOCHECK ADD 
	CONSTRAINT [DF_PARA_SOLOIMPIVA] DEFAULT ('') FOR [SOLOIMPIVA]
go

UPDATE PARA SET SOLOIMPIVA 	= ''
UPDATE PARA SET SOLOIMPIVA 	= SOLOIVA


 
/* 
**************************************************************
COME CANCELLARE UN CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[PARA] DROP CONSTRAINT
      DF_PARA_SOLOIVA
GO

ALTER TABLE [dbo].[PARA] DROP COLUMN 
       SOLOIVA
GO

