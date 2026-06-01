/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[U_ART_PR] ADD 
	 ART_DESIMB varchar(30) COLLATE Latin1_General_CI_AS NULL,
	 ART_LOTMIN numeric(6) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_ART_PR] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_ART_PR_ART_DESIMB] DEFAULT ('') FOR [ART_DESIMB],
	CONSTRAINT [DF_U_ART_PR_ART_LOTMIN] DEFAULT (0) FOR [ART_LOTMIN]
go

UPDATE U_ART_PR SET ART_CODIMB = SPACE(3)
UPDATE U_ART_PR SET ART_DESIMB = SPACE(30)
UPDATE U_ART_PR SET ART_LOTMIN = 0
