
/* ###################################################### DELETE CAMPI ##################################################### */


if exists(select * from sys.columns where name = 'ORD_CCODLIS' and object_id = object_id(N'[dbo].[VENDITE_TT]'))
BEGIN
	ALTER TABLE VENDITE_TT DROP CONSTRAINT DF_VENDITE_TT_ORD_CCODLIS
	ALTER TABLE VENDITE_TT DROP COLUMN ORD_CCODLIS
END


if exists(select * from sys.columns where name = 'ORD_IMPFORF' and object_id = object_id(N'[dbo].[VENDITE_DT]'))
BEGIN
	ALTER TABLE VENDITE_DT DROP CONSTRAINT DF_VENDITE_DT_ORD_IMPFORF
	ALTER TABLE VENDITE_DT DROP COLUMN ORD_IMPFORF
END

if exists(select * from sys.columns where name = 'ORD_PAGAALTEC' and object_id = object_id(N'[dbo].[VENDITE_DT]'))
BEGIN
	ALTER TABLE VENDITE_DT DROP CONSTRAINT DF_VENDITE_DT_ORD_PAGAALTEC
	ALTER TABLE VENDITE_DT DROP COLUMN ORD_PAGAALTEC
END

if exists(select * from sys.columns where name = 'ORD_DTPROGR' and object_id = object_id(N'[dbo].[VENDITE_DT]'))
BEGIN
	ALTER TABLE VENDITE_DT DROP CONSTRAINT DF_VENDITE_DT_ORD_DTPROGR
	ALTER TABLE VENDITE_DT DROP COLUMN ORD_DTPROGR
END


if exists(select * from sys.columns where name = 'ORD_COEFFIC' and object_id = object_id(N'[dbo].[VENDITE_DT]'))
BEGIN
	ALTER TABLE VENDITE_DT DROP CONSTRAINT DF_VENDITE_DT_ORD_COEFFIC
	ALTER TABLE VENDITE_DT DROP COLUMN ORD_COEFFIC 
END


if exists(select * from sys.columns where name = 'ORD_ZONA' and object_id = object_id(N'[dbo].[VENDITE_DT]'))
BEGIN
	ALTER TABLE VENDITE_DT DROP CONSTRAINT DF_VENDITE_DT_ORD_ZONA
	ALTER TABLE VENDITE_DT DROP COLUMN ORD_ZONA
END


if exists(select * from sys.columns where name = 'ORD_INTCLOSE' and object_id = object_id(N'[dbo].[VENDITE_DT]'))
BEGIN
	ALTER TABLE VENDITE_DT DROP CONSTRAINT DF_VENDITE_DT_ORD_INTCLOSE
	ALTER TABLE VENDITE_DT DROP COLUMN ORD_INTCLOSE
END

if exists(select * from sys.columns where name = 'ORD_FLGCON' and object_id = object_id(N'[dbo].[VENDITE_TT]'))
BEGIN
	ALTER TABLE VENDITE_TT DROP CONSTRAINT DF_VENDITE_TT_ORD_FLGCON
	ALTER TABLE VENDITE_TT DROP COLUMN ORD_FLGCON
END




/* ###################################################### INSERISCE CAMPI ##################################################### */


if NOT exists(select * from sys.columns where name = 'ORD_CCODLIS' and object_id = object_id(N'[dbo].[VENDITE_TT]'))

ALTER TABLE [DBO].[VENDITE_TT] ADD 
	ORD_CCODLIS varchar(5) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_VENDITE_TT_ORD_CCODLIS] DEFAULT ('')
GO


if NOT exists(select * from sys.columns where name = 'ORD_ATTICLOSE' and object_id = object_id(N'[dbo].[VENDITE_DT]'))

ALTER TABLE [DBO].[VENDITE_DT] ADD 
	ORD_ATTICLOSE bit NOT NULL CONSTRAINT [DF_VENDITE_DT_ORD_ATTICLOSE] DEFAULT (0)
GO


if NOT exists(select * from sys.columns where name = 'ORD_INTCLOSE' and object_id = object_id(N'[dbo].[VENDITE_TT]'))

ALTER TABLE [DBO].[VENDITE_TT] ADD 
	ORD_INTCLOSE bit NOT NULL CONSTRAINT [DF_VENDITE_TT_ORD_INTCLOSE] DEFAULT (0)
GO

