
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[RISUMANA] ADD 
	 CCOST1  varchar(13) COLLATE Latin1_General_CI_AS NULL,
	 PERCON1  numeric(17,3) NULL

go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[RISUMANA] WITH NOCHECK ADD 
	CONSTRAINT [DF_RISUMANA_CCOST1 ] DEFAULT ('') FOR [CCOST1 ],
	CONSTRAINT [DF_RISUMANA_PERCON1 ] DEFAULT ('0') FOR [PERCON1 ]
go

UPDATE RISUMANA SET CCOST1  = ''
UPDATE RISUMANA SET PERCON1  = 0


