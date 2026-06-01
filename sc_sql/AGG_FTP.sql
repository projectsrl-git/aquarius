/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_FTP_AN] ADD 
	 FTP_TIPCOM varchar(1) COLLATE Latin1_General_CI_AS NULL ,
	 FTP_NUMSER varchar(50) COLLATE Latin1_General_CI_AS NULL,
	 FTP_TIPACQ varchar(1) COLLATE Latin1_General_CI_AS NULL,
	 FTP_NUMDOC varchar(6) COLLATE Latin1_General_CI_AS NULL,
	 FTP_DATDOC varchar(10) COLLATE Latin1_General_CI_AS NULL,
	 FTP_CODFOR varchar(10) COLLATE Latin1_General_CI_AS NULL,
	 FTP_RAGFOR varchar(40) COLLATE Latin1_General_CI_AS NULL,
	 FTP_STAMPA varchar(1) COLLATE Latin1_General_CI_AS NULL,
	 FTP_EXECUTE bit NULL 

go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_FTP_AN] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_FTP_AN_FTP_TIPCOM] DEFAULT ('') FOR [FTP_TIPCOM],
	CONSTRAINT [DF_U_FTP_AN_FTP_NUMSER] DEFAULT ('') FOR [FTP_NUMSER],
	CONSTRAINT [DF_U_FTP_AN_FTP_TIPACQ] DEFAULT ('') FOR [FTP_TIPACQ],
	CONSTRAINT [DF_U_FTP_AN_FTP_NUMDOC] DEFAULT ('') FOR [FTP_NUMDOC],
	CONSTRAINT [DF_U_FTP_AN_FTP_DATDOC] DEFAULT ('') FOR [FTP_DATDOC],
	CONSTRAINT [DF_U_FTP_AN_FTP_CODFOR] DEFAULT ('') FOR [FTP_CODFOR],
	CONSTRAINT [DF_U_FTP_AN_FTP_RAGFOR] DEFAULT ('') FOR [FTP_RAGFOR],
	CONSTRAINT [DF_U_FTP_AN_FTP_STAMPA] DEFAULT ('') FOR [FTP_STAMPA],
	CONSTRAINT [DF_U_FTP_AN_FTP_EXECUTE] DEFAULT (0) FOR [FTP_EXECUTE]

go