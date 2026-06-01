/* 
***********************************************
INSERIMENTO NUOVO CAMPO "Motivazione scaduto"
***********************************************

*/
ALTER TABLE [dbo].[U_ORD_DD] ALTER COLUMN 
	 ORS_RAGSOC varchar(150) COLLATE Latin1_General_CI_AS
go

ALTER TABLE [dbo].[U_OFF_DD] ALTER COLUMN 
	 ORS_RAGSOC varchar(150) COLLATE Latin1_General_CI_AS
go

ALTER TABLE [dbo].[U_BOL_DD] ALTER COLUMN 
	 ORS_RAGSOC varchar(150) COLLATE Latin1_General_CI_AS
go

ALTER TABLE [dbo].[U_FAP_DD] ALTER COLUMN 
	 ORS_RAGSOC varchar(150) COLLATE Latin1_General_CI_AS
go