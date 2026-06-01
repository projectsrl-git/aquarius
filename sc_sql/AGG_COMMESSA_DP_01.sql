/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[COMMESSA_DP] ADD 
	 CODFIGPROF varchar(3) COLLATE Latin1_General_CI_AS NULL,
	 DESFIGPROF varchar(100) COLLATE Latin1_General_CI_AS NULL

go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[COMMESSA_DP] WITH NOCHECK ADD 

	CONSTRAINT [DF_COMMESSA_DP_CODFIGPROF] DEFAULT ('') FOR [CODFIGPROF],
	CONSTRAINT [DF_COMMESSA_DP_DESFIGPROF] DEFAULT ('') FOR [DESFIGPROF]
go


UPDATE COMMESSA_DP SET CODFIGPROF 	= ''
UPDATE COMMESSA_DP SET DESFIGPROF 	= ''


