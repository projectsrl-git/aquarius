
/*   
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_MAG_MO] ADD 
	MOV_QTANR numeric (19,4) NULL,
    MOV_GIANEG BIT NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_MAG_MO] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_MAG_MO_MOV_QTANR] DEFAULT (0) FOR [MOV_QTANR],
	CONSTRAINT [DF_U_MAG_MO_MOV_GIANEG] DEFAULT (0) FOR [MOV_GIANEG]
go

UPDATE U_MAG_MO SET MOV_GIANEG = 0
UPDATE U_MAG_MO SET MOV_QTANR = 0 
