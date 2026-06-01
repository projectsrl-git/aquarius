/* 
******************************************************************************
INSERIMENTO CONDIZIONATO DI UN NUOVO CAMPO PER NOTE DI TESTATA DDT
******************************************************************************
*/

if NOT exists(select * from sys.columns where name = 'ORD_NOTET' and object_id = object_id(N'[dbo].[L_BOL_TT]'))
	ALTER TABLE [dbo].[L_BOL_TT] ADD ORD_NOTET [text] COLLATE Latin1_General_CI_AS NULL
	go

if NOT exists(select * from SYS.default_constraints where name = 'DF_L_BOL_TT_ORD_NOTET' and parent_object_id = object_id(N'[dbo].[L_BOL_TT]'))
	ALTER TABLE [dbo].[L_BOL_TT] WITH NOCHECK ADD CONSTRAINT [DF_L_BOL_TT_ORD_NOTET] DEFAULT ('') FOR [ORD_NOTET]
	go

if NOT exists(select * FROM L_BOL_TT WHERE SUBSTRING(COALESCE(ORD_NOTET,''),1,1) <> '')
	UPDATE L_BOL_TT SET ORD_NOTET = ''
