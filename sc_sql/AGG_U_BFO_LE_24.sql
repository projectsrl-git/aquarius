
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/


ALTER TABLE [dbo].[U_BFO_LE] ADD 
	 LEG_CPA varchar(03) COLLATE Latin1_General_CI_AS NULL,
	 LEG_DESCPA varchar(70) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_BFO_LE] WITH NOCHECK ADD 
    CONSTRAINT [DF_U_BFO_LE_LEG_CPA] DEFAULT ('') FOR [LEG_CPA],
	CONSTRAINT [DF_U_BFO_LE_LEG_DESCPA] DEFAULT ('') FOR [LEG_DESCPA]
go

UPDATE U_BFO_LE SET LEG_CPA = ''
UPDATE U_BFO_LE SET LEG_DESCPA = ''








