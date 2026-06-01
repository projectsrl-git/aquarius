
/* ###################################################### ELIMINAZIONE CAMPI ##################################################### */


if exists(select * from sys.columns where name = 'ORD_ORAINIPRO' and object_id = object_id(N'[dbo].[VENDITE_TT]'))
BEGIN
	ALTER TABLE VENDITE_TT DROP CONSTRAINT DF_VENDITE_TT_ORD_ORAINIPRO
	ALTER TABLE VENDITE_TT DROP COLUMN ORD_ORAINIPRO
END

if exists(select * from sys.columns where name = 'ORD_ORAFINPRO' and object_id = object_id(N'[dbo].[VENDITE_TT]'))
BEGIN
	ALTER TABLE VENDITE_TT DROP CONSTRAINT DF_VENDITE_TT_ORD_ORAFINPRO
	ALTER TABLE VENDITE_TT DROP COLUMN ORD_ORAFINPRO
END
