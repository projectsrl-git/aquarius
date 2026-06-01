/* 
********************************************************************************************************
AGGIUNTA CAMPO "ART_CODUDI"
********************************************************************************************************
*/

ALTER TABLE [dbo].[U_ART_AN] ADD 
	ART_CODUDI varchar(20) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_ART_AN_ART_CODUDI] DEFAULT ('')
go
