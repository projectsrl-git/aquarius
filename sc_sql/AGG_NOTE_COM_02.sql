
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[NOTE_COM] ADD 
	[NOC_TOTMC] [bit] NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[NOTE_COM] WITH NOCHECK ADD 
	CONSTRAINT [DF_NOTE_COM_NOC_TOTMC] DEFAULT (0) FOR [NOC_TOTMC]
go

UPDATE NOTE_COM SET NOC_TOTMC = 0

DELETE FROM NOTE_COM WHERE NOT_CODICE = 'TOT_MC'

INSERT INTO NOTE_COM (
	NOT_CODSOC,
	NOT_CODICE,
	NOT_TESTO,
	NOC_TOTMC)
VALUES (
	'01',
	'TOT_MC',
	CHAR(13)+'TOTALE METRICUBI :  .TOTMETRICUBI',
	1)
