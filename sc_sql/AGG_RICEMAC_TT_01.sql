
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[ricemac_tt] ADD 
		DATATARICE varchar (10) COLLATE Latin1_General_CI_AS NULL,
		PROGRICE numeric(10,0)  NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[ricemac_tt] WITH NOCHECK ADD 
        CONSTRAINT [DF_ricemac_tt_DATATARICE] DEFAULT ('') FOR [DATATARICE],
        CONSTRAINT [DF_ricemac_tt_PROGRICE] DEFAULT (0) FOR [PROGRICE]
go



UPDATE ricemac_tt SET DATATARICE 	= ''
UPDATE ricemac_tt SET PROGRICE 	= 0


