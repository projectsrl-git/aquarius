/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[U_MAG_AN] ADD 
	 MAG_QTAKGA numeric(11,2) NULL,
	 MAG_QTAMQA numeric(11,2) NULL,
	 MAG_QTAMLA numeric(11,2) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_MAG_AN] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_MAG_AN_MAG_QTAKGA] DEFAULT (0) FOR [MAG_QTAKGA],
	CONSTRAINT [DF_U_MAG_AN_MAG_QTAMQA] DEFAULT (0) FOR [MAG_QTAMQA],
	CONSTRAINT [DF_U_MAG_AN_MAG_QTAMLA] DEFAULT (0) FOR [MAG_QTAMLA]
go

UPDATE U_MAG_AN SET MAG_QTAKGA = 0
UPDATE U_MAG_AN SET MAG_QTAMQA = 0
UPDATE U_MAG_AN SET MAG_QTAMLA = 0

