
/* ###################################################### ELIMINAZIONE CAMPI ##################################################### */

if exists(select * from sys.columns where name = 'ORD_FATTURAT' and object_id = object_id(N'[dbo].[VENDITE_DD]'))
BEGIN
	ALTER TABLE VENDITE_DD DROP CONSTRAINT DF_VENDITE_DD_ORD_FATTURAT
	ALTER TABLE VENDITE_DD DROP COLUMN ORD_FATTURAT
END
