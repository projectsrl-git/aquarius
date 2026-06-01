/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[FATTURABILE_X] ADD 
	 CODFIGPROF varchar(3) COLLATE Latin1_General_CI_AS NULL,
	 DESFIGPROF varchar(100) COLLATE Latin1_General_CI_AS NULL

go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[FATTURABILE_X] WITH NOCHECK ADD 

	CONSTRAINT [DF_FATTURABILE_X_CODFIGPROF] DEFAULT ('') FOR [CODFIGPROF],
	CONSTRAINT [DF_FATTURABILE_X_DESFIGPROF] DEFAULT ('') FOR [DESFIGPROF]
go


UPDATE FATTURABILE_X SET CODFIGPROF 	= ''
UPDATE FATTURABILE_X SET DESFIGPROF 	= ''


