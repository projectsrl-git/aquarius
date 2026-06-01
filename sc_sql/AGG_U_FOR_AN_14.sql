/* 
**************************************************************
COME ALLARGARE UN CAMPO ESISTENTE
**************************************************************
*/
ALTER TABLE [dbo].[U_FOR_AN] ALTER COLUMN
	 	 for_bae varchar(10) COLLATE Latin1_General_CI_AS NULL
go
ALTER TABLE [dbo].[U_FOR_AN] ALTER COLUMN
	 	 for_bpf varchar(10) COLLATE Latin1_General_CI_AS NULL
go

