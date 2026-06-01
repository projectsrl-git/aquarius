/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[FATTURABILE_S] ADD 
	 CODFIGPROF varchar(3) COLLATE Latin1_General_CI_AS NULL,
	 DESFIGPROF varchar(100) COLLATE Latin1_General_CI_AS NULL

go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[FATTURABILE_S] WITH NOCHECK ADD 

	CONSTRAINT [DF_FATTURABILE_S_CODFIGPROF] DEFAULT ('') FOR [CODFIGPROF],
	CONSTRAINT [DF_FATTURABILE_S_DESFIGPROF] DEFAULT ('') FOR [DESFIGPROF]
go


UPDATE FATTURABILE_S SET CODFIGPROF 	= ''
UPDATE FATTURABILE_S SET DESFIGPROF 	= ''


