/* 
******************************************************************************
INSERIMENTO CONDIZIONATO DI UN NUOVO CAMPO PER NOTE DI TESTATA DDT
******************************************************************************
*/

if NOT exists(select * from sys.columns where name = 'ORD_NOTET' and object_id = object_id(N'[dbo].[U_BOL_TT]'))
	ALTER TABLE [dbo].[U_BOL_TT] ADD ORD_NOTET [text] COLLATE Latin1_General_CI_AS NULL
	go

if NOT exists(select * from SYS.default_constraints where name = 'DF_U_BOL_TT_ORD_NOTET' and parent_object_id = object_id(N'[dbo].[U_BOL_TT]'))
	ALTER TABLE [dbo].[U_BOL_TT] WITH NOCHECK ADD CONSTRAINT [DF_U_BOL_TT_ORD_NOTET] DEFAULT ('') FOR [ORD_NOTET]
	go

if NOT exists(select * FROM U_BOL_TT WHERE SUBSTRING(COALESCE(ORD_NOTET,''),1,1) <> '')
	UPDATE U_BOL_TT SET ORD_NOTET = ''
