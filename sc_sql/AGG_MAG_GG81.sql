
/*   
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_MAG_GG] ADD 
	MAG_QTANR numeric (19,4) NULL,
    MAG_GIANEG BIT NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_MAG_GG] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_MAG_GG_MAG_QTANR] DEFAULT (0) FOR [MAG_QTANR],
	CONSTRAINT [DF_U_MAG_GG_MAG_GIANEG] DEFAULT (0) FOR [MAG_GIANEG]
go

UPDATE U_MAG_GG SET MAG_GIANEG = 0
UPDATE U_MAG_GG SET MAG_QTANR = 0 
