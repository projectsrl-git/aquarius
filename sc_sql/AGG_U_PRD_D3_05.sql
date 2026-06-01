
/* 
**************************************************************
COME ELIMINARE I VINCOLI DI UN CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_PRD_D3] DROP CONSTRAINT [DF_U_PRD_D3_PR3_CDADIN]
go

/* 
**************************************************************
COME MODIFICARE UN CAMPO ESISTENTE IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_PRD_D3] ALTER COLUMN
	 PR3_CDADIN text COLLATE Latin1_General_CI_AS NULL
GO


--/* 
--**************************************************************
--COME CANCELLARE UN CAMPO IN UNA TABELLA
--**************************************************************
--*/
--ALTER TABLE [dbo].[U_PRD_D3] DROP COLUMN 
--	 PR3_CDADIN
--GO


/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_PRD_D3] ADD 
	PR3_QTADGI numeric(17,6) NULL,
	PR3_CODREC varchar(16) COLLATE Latin1_General_CI_AS NULL,
	PR3_DESREC varchar(50) COLLATE Latin1_General_CI_AS NULL,
	PR3_CDRCIN text COLLATE Latin1_General_CI_AS NULL ,
	PR3_QTAREC numeric(17,6) NULL,
	PR3_QTRCGI numeric(17,6) NULL
go


ALTER TABLE [dbo].[U_PRD_D3] WITH NOCHECK ADD
	CONSTRAINT [DF_U_PRD_D3_PR3_QTADGI] DEFAULT (0) FOR [PR3_QTADGI],
	CONSTRAINT [DF_U_PRD_D3_PR3_CODREC] DEFAULT ('') FOR [PR3_CODREC],
	CONSTRAINT [DF_U_PRD_D3_PR3_DESREC] DEFAULT ('') FOR [PR3_DESREC],
	CONSTRAINT [DF_U_PRD_D3_PR3_CDRCIN] DEFAULT ('') FOR [PR3_CDRCIN],
	CONSTRAINT [DF_U_PRD_D3_PR3_QTAREC] DEFAULT (0) FOR [PR3_QTAREC],
	CONSTRAINT [DF_U_PRD_D3_PR3_QTRCGI] DEFAULT (0) FOR [PR3_QTRCGI]
go

UPDATE U_PRD_D3 SET PR3_QTADGI = 0
UPDATE U_PRD_D3 SET PR3_CODREC = ''
UPDATE U_PRD_D3 SET PR3_DESREC = ''
UPDATE U_PRD_D3 SET PR3_CDRCIN = ''
UPDATE U_PRD_D3 SET PR3_QTAREC = 0
UPDATE U_PRD_D3 SET PR3_QTRCGI = 0
