/* 
****************************************************************************************************************
VARIAZIONE DIMENSIONI CAMPO CODICE ARTICOLO FORNITORE - U_ART_PR.ART_NOTA1/2/3/4/5 DA VARCHAR(40) A VARCHAR(100)
****************************************************************************************************************
*/
ALTER TABLE [dbo].[U_ART_PR] ALTER COLUMN
	 ART_NOTA1 varchar(100) COLLATE Latin1_General_CI_AS
GO

ALTER TABLE [dbo].[U_ART_PR] ALTER COLUMN
	 ART_NOTA2 varchar(100) COLLATE Latin1_General_CI_AS
GO

ALTER TABLE [dbo].[U_ART_PR] ALTER COLUMN
	 ART_NOTA3 varchar(100) COLLATE Latin1_General_CI_AS
GO

ALTER TABLE [dbo].[U_ART_PR] ALTER COLUMN
	 ART_NOTA4 varchar(100) COLLATE Latin1_General_CI_AS
GO

ALTER TABLE [dbo].[U_ART_PR] ALTER COLUMN
	 ART_NOTA5 varchar(100) COLLATE Latin1_General_CI_AS
GO
