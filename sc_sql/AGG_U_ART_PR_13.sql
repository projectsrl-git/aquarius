
/* 
******************************************************************************
INSERIMENTO CONDIZIONATO DI UN NUOVO CAMPO IN UNA TABELLA (DA SQL 2005 IN POI)
******************************************************************************
*/

if NOT exists(select * from sys.columns where name = 'ART_GGROTA' and object_id = object_id(N'[dbo].[U_ART_PR]'))
BEGIN
	BEGIN
		ALTER TABLE [dbo].[U_ART_PR] ADD ART_GGROTA numeric(10,2) NULL
	END
	
	BEGIN
		ALTER TABLE [dbo].[U_ART_PR] WITH NOCHECK ADD CONSTRAINT [DF_U_ART_PR_ART_GGROTA] DEFAULT (0) FOR [ART_GGROTA]
	END
	
	BEGIN
		UPDATE U_ART_PR SET ART_GGROTA = 0
	END
END