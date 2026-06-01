/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[COMMESSA_DC] ADD 
	 CODFIGPROF varchar(3) COLLATE Latin1_General_CI_AS NULL,
	 DESFIGPROF varchar(100) COLLATE Latin1_General_CI_AS NULL

go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[COMMESSA_DC] WITH NOCHECK ADD 

	CONSTRAINT [DF_COMMESSA_DC_CODFIGPROF] DEFAULT ('') FOR [CODFIGPROF],
	CONSTRAINT [DF_COMMESSA_DC_DESFIGPROF] DEFAULT ('') FOR [DESFIGPROF]
go


UPDATE COMMESSA_DC SET CODFIGPROF 	= ''
UPDATE COMMESSA_DC SET DESFIGPROF 	= ''


