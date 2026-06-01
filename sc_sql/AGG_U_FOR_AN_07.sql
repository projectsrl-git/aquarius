/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_FOR_AN] ADD 
	 	 FOR_CONERA varchar(13) COLLATE Latin1_General_CI_AS NULL,
	 	 FOR_CONPRV varchar(13) COLLATE Latin1_General_CI_AS NULL,
		 FOR_MASSIM numeric (17,3) NULL,
		 FOR_FATTOT numeric (17,3) NULL,
		 FOR_PERENA numeric (17,3) NULL,
	 	 FOR_CONENA varchar(13) COLLATE Latin1_General_CI_AS NULL

go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_FOR_AN] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_FOR_AN_FOR_CONERA] DEFAULT ('    ') FOR [FOR_CONERA],
	CONSTRAINT [DF_U_FOR_AN_FOR_CONPRV] DEFAULT ('    ') FOR [FOR_CONPRV],
	CONSTRAINT [DF_U_PCK_DD_FOR_MASSIM] DEFAULT ('0')    FOR [FOR_MASSIM],
	CONSTRAINT [DF_U_PCK_DD_FOR_FATTOT] DEFAULT ('0')    FOR [FOR_FATTOT],
	CONSTRAINT [DF_U_PCK_DD_FOR_PERENA] DEFAULT ('0')    FOR [FOR_PERENA],
	CONSTRAINT [DF_U_FOR_AN_FOR_CONENA] DEFAULT ('    ') FOR [FOR_CONENA]
go

UPDATE U_FOR_AN SET FOR_CONERA 	= SPACE(13)
UPDATE U_FOR_AN SET FOR_CONPRV 	= SPACE(13)
UPDATE U_FOR_AN SET FOR_MASSIM 	= 0
UPDATE U_FOR_AN SET FOR_FATTOT 	= 0
UPDATE U_FOR_AN SET FOR_PERENA 	= 0
UPDATE U_FOR_AN SET FOR_CONENA 	= SPACE(13)
