/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[CLIENTIC] ADD 
	FatFrazio BIT NULL,
	FatFrazioPerc numeric(10,2) NULL,
	FatFrazioNum numeric(10,0) NULL,
	FatFrazioDen numeric(10,0) NULL,
	FatFrazioNote text NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[CLIENTIC] WITH NOCHECK ADD 
	CONSTRAINT [DF_CLIENTIC_FatFrazio] DEFAULT (0) FOR [FatFrazio],
	CONSTRAINT [DF_CLIENTIC_FatFrazioPerc] DEFAULT (0) FOR [FatFrazioPerc],
	CONSTRAINT [DF_CLIENTIC_FatFrazioNum] DEFAULT (0) FOR [FatFrazioNum],
	CONSTRAINT [DF_CLIENTIC_FatFrazioDen] DEFAULT (0) FOR [FatFrazioDen],
	CONSTRAINT [DF_CLIENTIC_FatFrazioNote] DEFAULT ('') FOR [FatFrazioNote]
go


UPDATE CLIENTIC SET FatFrazio = 0
UPDATE CLIENTIC SET FatFrazioPerc = 0
UPDATE CLIENTIC SET FatFrazioNum = 0
UPDATE CLIENTIC SET FatFrazioDen = 0
UPDATE CLIENTIC SET FatFrazioNote = ''
