/***************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
***************************************************************/

ALTER TABLE [dbo].[U_BFO_DD] ADD 
	ORD_SYSRDC varchar(10) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_BFO_DD_ORD_SYSRDC] DEFAULT ('')
go
