
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_MAG_MO] ADD 
	 MOV_LEGSYS varchar(10) COLLATE Latin1_General_CI_AS NULL,
	 MOV_CODCAS varchar(06) COLLATE Latin1_General_CI_AS NULL
go

-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_MAG_MO] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_MAG_MO_MOV_LEGSYS] DEFAULT ('') FOR [MOV_LEGSYS],
	CONSTRAINT [DF_U_MAG_MO_MOV_CODCAS] DEFAULT ('') FOR [MOV_CODCAS]
go

UPDATE U_MAG_MO SET MOV_LEGSYS = SPACE(10)
UPDATE U_MAG_MO SET MOV_CODCAS = SPACE(06)


