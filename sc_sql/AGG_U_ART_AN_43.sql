/* 
********************************************************************************************************
ELIMINAZIONE CAMPO "ART_CODUDI"
AGGIUNTA CAMPO "ART_FLGUDI"
********************************************************************************************************
*/

if exists(select * from sys.columns where name = 'ART_CODUDI' and object_id = object_id(N'[dbo].[U_ART_AN]'))
BEGIN
	ALTER TABLE U_ART_AN DROP CONSTRAINT DF_U_ART_AN_ART_CODUDI
	ALTER TABLE U_ART_AN DROP COLUMN ART_CODUDI
END

ALTER TABLE [dbo].[U_ART_AN] ADD 
	ART_FLGUDI BIT NOT NULL CONSTRAINT [DF_U_ART_AN_ART_FLGUDI] DEFAULT (0)
go
