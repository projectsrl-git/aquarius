/* 
**************************************************************
INSERIMENTO NUOVO CAMPO PER DATA SCADENZA PASSWORD OPERATORE
**************************************************************
*/
ALTER TABLE [dbo].[RES_OPER] ADD 
	DATSCAPWD varchar(10) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_RES_OPER_DATSCAPWD] DEFAULT ('')
go
