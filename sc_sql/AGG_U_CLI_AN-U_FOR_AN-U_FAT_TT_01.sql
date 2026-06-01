/***********************************************/
/* ALTERAZIONE DELLA SOLA DIMENSIONE DEL CAMPO */
/***********************************************/

ALTER TABLE [dbo].[U_CLI_AN] ALTER COLUMN
	 CLI_CLIES varchar(24) COLLATE Latin1_General_CI_AS NOT NULL
GO

ALTER TABLE [dbo].[U_CLI_AN] ALTER COLUMN
	 CLI_NSES varchar(24) COLLATE Latin1_General_CI_AS NOT NULL
GO

ALTER TABLE [dbo].[U_FOR_AN] ALTER COLUMN
	 FOR_CLIES varchar(24) COLLATE Latin1_General_CI_AS NOT NULL
GO

ALTER TABLE [dbo].[U_FOR_AN] ALTER COLUMN
	 FOR_NSES varchar(24) COLLATE Latin1_General_CI_AS NOT NULL
GO


ALTER TABLE [dbo].[U_FAT_TT] ALTER COLUMN
	 ORD_NUMLEI varchar(24) COLLATE Latin1_General_CI_AS NOT NULL
GO

ALTER TABLE [dbo].[U_FAT_TT] ALTER COLUMN
	 ORD_NRPLEI varchar(24) COLLATE Latin1_General_CI_AS NOT NULL
GO

