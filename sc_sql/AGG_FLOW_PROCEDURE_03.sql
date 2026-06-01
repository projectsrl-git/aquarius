
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[FLOW_PROCEDURE] ALTER COLUMN 
	[ID_PROCEDURA] varchar(20) COLLATE Latin1_General_CI_AS NULL 

ALTER TABLE [dbo].[FLOW_PROCEDURE] ALTER COLUMN 
	[ID_PROCEDURA_PADRE] varchar(20) COLLATE Latin1_General_CI_AS NULL 
go

