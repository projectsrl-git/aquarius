
ALTER TABLE [dbo].[U_BFO_DD] ADD ORD_SYSMAG varchar (10) COLLATE Latin1_General_CI_AS NULL
GO

ALTER TABLE [dbo].[U_BFO_DD] WITH NOCHECK ADD CONSTRAINT [DF_U_BFO_DD_ORD_SYSMAG] DEFAULT ('') FOR [ORD_SYSMAG]
GO

UPDATE U_BFO_DD SET ORD_SYSMAG = ''
GO

/* 
/* 
******************************************************************************
INSERIMENTO CONDIZIONATO DI UN NUOVO CAMPO IN UNA TABELLA (DA SQL 2005 IN POI)
******************************************************************************
*/

if NOT exists(select * from sys.columns where name = 'ORD_SYSMAG' and object_id = object_id(N'[dbo].[U_BFO_DD]'))
BEGIN
	BEGIN
		ALTER TABLE [dbo].[U_BFO_DD] ADD ORD_SYSMAG varchar (10) COLLATE Latin1_General_CI_AS NULL
	END
	BEGIN
		ALTER TABLE [dbo].[U_BFO_DD] WITH NOCHECK ADD CONSTRAINT [DF_U_BFO_DD_ORD_SYSMAG] DEFAULT ('') FOR [ORD_SYSMAG]
	END
	BEGIN
		UPDATE U_BFO_DD SET ORD_SYSMAG = ORD_LEGSYS
	END
END
*/