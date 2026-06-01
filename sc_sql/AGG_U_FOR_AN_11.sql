/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_FOR_AN] ADD 
		 FOR_PERCON1 numeric (10,3) NULL,
		 FOR_PERCON2 numeric (10,3) NULL,
		 FOR_PERCON3 numeric (10,3) NULL,
		 FOR_PERCON4 numeric (10,3) NULL,
		 FOR_PERCON5 numeric (10,3) NULL

go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_FOR_AN] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_PCK_DD_FOR_PERCON1] DEFAULT ('0')    FOR [FOR_PERCON1],
	CONSTRAINT [DF_U_PCK_DD_FOR_PERCON2] DEFAULT ('0')    FOR [FOR_PERCON2],
	CONSTRAINT [DF_U_PCK_DD_FOR_PERCON3] DEFAULT ('0')    FOR [FOR_PERCON3],
	CONSTRAINT [DF_U_PCK_DD_FOR_PERCON4] DEFAULT ('0')    FOR [FOR_PERCON4],
	CONSTRAINT [DF_U_PCK_DD_FOR_PERCON5] DEFAULT ('0')    FOR [FOR_PERCON5]
go

UPDATE U_FOR_AN SET FOR_PERCON1 	= 0
UPDATE U_FOR_AN SET FOR_PERCON2 	= 0
UPDATE U_FOR_AN SET FOR_PERCON3 	= 0
UPDATE U_FOR_AN SET FOR_PERCON4 	= 0
UPDATE U_FOR_AN SET FOR_PERCON5 	= 0
