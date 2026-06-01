
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_ART_AN] ADD 
		art_artsimi varchar (16) COLLATE Latin1_General_CI_AS NULL,
		ART_DESARS varchar (40) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[U_ART_AN] WITH NOCHECK ADD 
        CONSTRAINT [DF_U_ART_AN_art_artsimi] DEFAULT ('') FOR [art_artsimi],
        CONSTRAINT [DF_U_ART_AN_ART_DESARS] DEFAULT ('') FOR [ART_DESARS]
go



UPDATE U_ART_AN SET art_artsimi 	= ''
UPDATE U_ART_AN SET ART_DESARS 	= ''

