
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[CONTRMDB_DD] ADD 
	ORD_ANTECO numeric(17,2) NOT NULL CONSTRAINT [DF_CONTRMDB_DD_ORD_ANTECO] DEFAULT (0)
go


ALTER TABLE [dbo].[CONTRMDB_DD] ADD 
	ORD_BOECO numeric(4,0) NOT NULL CONSTRAINT [DF_CONTRMDB_DD_ORD_BOECO] DEFAULT (0)
go


ALTER TABLE [dbo].[CONTRMDB_DD] ADD 
	ORD_DTSCEC varchar(10) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_CONTRMDB_DD_ORD_DTSCEC] DEFAULT ('')
go



ALTER TABLE [dbo].[CONTRMDB_DD] ADD 
	ORD_DTSCFO varchar(10) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_CONTRMDB_DD_ORD_DTSCFO] DEFAULT ('')
go

