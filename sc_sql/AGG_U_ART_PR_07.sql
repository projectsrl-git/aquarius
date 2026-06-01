
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_ART_PR] ADD 
	ART_BASADE varchar (1) COLLATE Latin1_General_CI_AS NULL,
	ART_MICROF BIT NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[U_ART_PR] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_ART_PR_ART_BASADE] DEFAULT ('') FOR [ART_BASADE],
	CONSTRAINT [DF_U_ART_PR_ART_MICROF] DEFAULT (0) FOR [ART_MICROF]
go

UPDATE U_ART_PR SET ART_BASADE = ''
UPDATE U_ART_PR SET ART_MICROF = 0
