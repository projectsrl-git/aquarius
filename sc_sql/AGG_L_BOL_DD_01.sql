
ALTER TABLE [dbo].[L_BOL_DD] ADD ORD_SYSMAG varchar (10) COLLATE Latin1_General_CI_AS NULL
GO

ALTER TABLE [dbo].[L_BOL_DD] WITH NOCHECK ADD CONSTRAINT [DF_L_BOL_DD_ORD_SYSMAG] DEFAULT ('') FOR [ORD_SYSMAG]
GO

UPDATE L_BOL_DD SET ORD_SYSMAG = ''
GO

/* 
/* 
******************************************************************************
INSERIMENTO CONDIZIONATO DI UN NUOVO CAMPO IN UNA TABELLA (DA SQL 2005 IN POI)
******************************************************************************
*/

if NOT exists(select * from sys.columns where name = 'ORD_SYSMAG' and object_id = object_id(N'[dbo].[L_BOL_DD]'))
BEGIN
	BEGIN
		ALTER TABLE [dbo].[L_BOL_DD] ADD ORD_SYSMAG varchar (10) COLLATE Latin1_General_CI_AS NULL
	END
	BEGIN
		ALTER TABLE [dbo].[L_BOL_DD] WITH NOCHECK ADD CONSTRAINT [DF_L_BOL_DD_ORD_SYSMAG] DEFAULT ('') FOR [ORD_SYSMAG]
	END
	BEGIN
		UPDATE L_BOL_DD SET ORD_SYSMAG = ORD_LEGSYS
	END
END
*/