/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[COMMESSA_DP] ADD 
	 CODUTENTE varchar(10) COLLATE Latin1_General_CI_AS NULL,
	 DESUTENTE varchar(100) COLLATE Latin1_General_CI_AS NULL,
	 COMUNE varchar(100) COLLATE Latin1_General_CI_AS NULL,
	 PROVINCIA varchar(2) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[COMMESSA_DP] WITH NOCHECK ADD 
	CONSTRAINT [DF_COMMESSA_DC_CODUTENTE] DEFAULT ('') FOR [CODUTENTE],
	CONSTRAINT [DF_COMMESSA_DC_DESUTENTE] DEFAULT ('') FOR [DESUTENTE],
	CONSTRAINT [DF_COMMESSA_DC_COMUNE] DEFAULT ('') FOR [COMUNE],
	CONSTRAINT [DF_COMMESSA_DC_PROVINCIA] DEFAULT ('') FOR [PROVINCIA]
go


UPDATE COMMESSA_DP SET CODUTENTE = ''
UPDATE COMMESSA_DP SET DESUTENTE = ''
UPDATE COMMESSA_DP SET COMUNE    = ''
UPDATE COMMESSA_DP SET PROVINCIA = ''

