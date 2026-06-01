
/* 
*************************************************************************************
ELIMINAZIONE CAMPI IN TABELLE U_CLI_AN / U_FOR_AN
*************************************************************************************
*/

if exists(select * from sys.columns where name = 'CLI_TLINGUA' and object_id = object_id(N'[dbo].[U_CLI_AN]'))
BEGIN
	ALTER TABLE [dbo].[U_CLI_AN] DROP CONSTRAINT DF_U_CLI_AN_CLI_TLINGUA
	ALTER TABLE [dbo].[U_CLI_AN] DROP COLUMN CLI_TLINGUA
END

if exists(select * from sys.columns where name = 'FOR_TLINGUA' and object_id = object_id(N'[dbo].[U_FOR_AN]'))
BEGIN
	ALTER TABLE [dbo].[U_FOR_AN] DROP CONSTRAINT DF_U_FOR_AN_FOR_TLINGUA
	ALTER TABLE [dbo].[U_FOR_AN] DROP COLUMN FOR_TLINGUA
END
