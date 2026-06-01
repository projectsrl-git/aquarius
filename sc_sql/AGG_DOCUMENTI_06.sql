/* 
**************************************************************
COME ALLARGARE UN CAMPO ESISTENTE
**************************************************************
*/
ALTER TABLE [dbo].[U_FAT_TT] ALTER COLUMN
	 	 ORD_BPRES varchar(10) COLLATE Latin1_General_CI_AS NULL
go

ALTER TABLE [dbo].[U_RIC_TT] ALTER COLUMN
	 	 RIC_BAPRES varchar(10) COLLATE Latin1_General_CI_AS NULL
go

ALTER TABLE [dbo].[U_RIC_TT] ALTER COLUMN
	 	 RIC_BACLI varchar(10) COLLATE Latin1_General_CI_AS NULL
go

ALTER TABLE [dbo].[U_RIC_DD] ALTER COLUMN
	 	 RIC_BAPRES varchar(10) COLLATE Latin1_General_CI_AS NULL
go

ALTER TABLE [dbo].[PARA] ALTER COLUMN
	 	 CODICE varchar(20) COLLATE Latin1_General_CI_AS NULL
go
ALTER TABLE [dbo].[U_RID_AN] ALTER COLUMN
	 	 RID_BANCA varchar(10) COLLATE Latin1_General_CI_AS NULL
go
