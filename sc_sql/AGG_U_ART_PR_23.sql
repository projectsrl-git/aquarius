/* 
**********************************************************************
VARIAZIONE DIMENSIONI CAMPI ART_DSCLIT* DA VARCHAR(10) A VARCHAR(100)
**********************************************************************
*/
ALTER TABLE [dbo].[U_ART_PR] ALTER COLUMN
	 ART_DSCLIT1 varchar(200) COLLATE Latin1_General_CI_AS
GO
ALTER TABLE [dbo].[U_ART_PR] ALTER COLUMN
	 ART_DSCLIT2 varchar(200) COLLATE Latin1_General_CI_AS
GO
ALTER TABLE [dbo].[U_ART_PR] ALTER COLUMN
	 ART_DSCLIT3 varchar(200) COLLATE Latin1_General_CI_AS
GO
ALTER TABLE [dbo].[U_ART_PR] ALTER COLUMN
	 ART_DSCLIT4 varchar(200) COLLATE Latin1_General_CI_AS
GO
ALTER TABLE [dbo].[U_ART_PR] ALTER COLUMN
	 ART_DSCLIT5 varchar(200) COLLATE Latin1_General_CI_AS
GO
